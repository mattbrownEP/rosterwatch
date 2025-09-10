import logging
from datetime import datetime, timedelta
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
import atexit

from app import app, db
from models import MonitoredURL, StaffChange, ScrapingLog, StaffListSnapshot
from scraper import StaffDirectoryScraper
from email_service import EmailService
from open_records_service import OpenRecordsService

logger = logging.getLogger(__name__)

scheduler = None
scraper = StaffDirectoryScraper()
email_service = EmailService()

def start_scheduler():
    """Start the background scheduler for monitoring URLs."""
    global scheduler

    if scheduler is not None:
        return  # Already started

    scheduler = BackgroundScheduler(daemon=True)

    # Schedule monitoring task to run every 30 minutes
    scheduler.add_job(
        func=monitor_all_urls,
        trigger=IntervalTrigger(minutes=30),
        id='monitor_urls',
        name='Monitor all URLs for changes',
        replace_existing=True
    )

    # Schedule cleanup task to run daily
    scheduler.add_job(
        func=cleanup_old_logs,
        trigger=IntervalTrigger(hours=24),
        id='cleanup_logs',
        name='Cleanup old scraping logs',
        replace_existing=True
    )

    scheduler.start()
    logger.info("Scheduler started successfully")

    # Shut down the scheduler when exiting the app
    atexit.register(lambda: scheduler.shutdown())

def monitor_all_urls():
    """Monitor all active URLs for changes."""
    with app.app_context():
        try:
            logger.info("Starting scheduled monitoring of all URLs")

            active_urls = MonitoredURL.query.filter_by(is_active=True).all()
            logger.info(f"Found {len(active_urls)} active URLs to monitor")

            for monitored_url in active_urls:
                try:
                    monitor_single_url(monitored_url)
                except Exception as e:
                    logger.error(f"Error monitoring URL {monitored_url.url}: {str(e)}")

                    # Log the error
                    log_entry = ScrapingLog(
                        monitored_url_id=monitored_url.id,
                        status='error',
                        message=f"Monitoring error: {str(e)}"
                    )
                    db.session.add(log_entry)

            db.session.commit()
            logger.info("Completed scheduled monitoring cycle")

        except Exception as e:
            logger.error(f"Error in monitor_all_urls: {str(e)}")
            db.session.rollback()

def monitor_single_url(monitored_url):
    """Monitor a single URL for changes."""
    logger.info(f"Monitoring {monitored_url.name}: {monitored_url.url}")

    # Scrape the current staff directory
    scraper = StaffDirectoryScraper()
    staff_list, content_hash, _ = scraper.scrape_staff_directory(monitored_url.url)

    if staff_list is None:
        # Scraping failed
        log_entry = ScrapingLog(
            monitored_url_id=monitored_url.id,
            status='error',
            message=content_hash  # Error message in this case
        )
        db.session.add(log_entry)
        logger.warning(f"Failed to scrape {monitored_url.url}: {content_hash}")
        return

    # Check if content has changed
    if monitored_url.last_content_hash and monitored_url.last_content_hash != content_hash:
        logger.info(f"Changes detected for {monitored_url.name}")

        # Get previous staff list for comparison
        previous_staff_list = get_previous_staff_list(monitored_url.id)

        if previous_staff_list:
            # Compare and detect specific changes
            changes = scraper.compare_staff_lists(previous_staff_list, staff_list)

            if changes:
                # Classify changes for Open Records priority
                open_records_service = OpenRecordsService()

                # Save changes to database
                for change in changes:
                    # Classify the change
                    classification = open_records_service.classify_staff_change(
                        change['staff_name'], change['staff_title'], change['change_type']
                    )

                    staff_change = StaffChange(
                        monitored_url_id=monitored_url.id,
                        change_type=change['change_type'],
                        staff_name=change['staff_name'],
                        staff_title=change['staff_title'],
                        change_description=change['change_description'],
                        position_importance=classification['position_importance'],
                        likely_contract_value=classification['contract_likelihood']
                    )
                    db.session.add(staff_change)

                # Send email notification
                if email_service.send_change_alert(
                    monitored_url.email,
                    monitored_url.name,
                    changes,
                    monitored_url.url
                ):
                    # Mark changes as email sent
                    for change in changes:
                        staff_change = StaffChange.query.filter_by(
                            monitored_url_id=monitored_url.id,
                            change_type=change['change_type'],
                            staff_name=change['staff_name']
                        ).order_by(StaffChange.id.desc()).first()
                        if staff_change:
                            staff_change.email_sent = True

                logger.info(f"Detected and recorded {len(changes)} changes for {monitored_url.name}")
        else:
            # First time monitoring or no previous data
            logger.info(f"No previous data for comparison for {monitored_url.name}")

    # Update monitoring record
    monitored_url.last_checked = datetime.utcnow()
    monitored_url.last_content_hash = content_hash

    # Store current staff list for future comparison
    store_staff_list(monitored_url.id, staff_list)

    # Log successful scraping
    log_entry = ScrapingLog(
        monitored_url_id=monitored_url.id,
        status='success',
        message=f"Successfully scraped {len(staff_list)} staff members"
    )
    db.session.add(log_entry)

def get_previous_staff_list(monitored_url_id):
    """Retrieve the previous staff list for comparison."""
    try:
        # Get the most recent staff snapshot for this URL
        latest_snapshot = StaffListSnapshot.query.filter_by(
            monitored_url_id=monitored_url_id
        ).order_by(StaffListSnapshot.created_at.desc()).first()

        if latest_snapshot:
            logger.debug(f"Retrieved previous staff list for URL {monitored_url_id} with {len(latest_snapshot.staff_data)} staff members")
            return latest_snapshot.staff_data
        else:
            logger.debug(f"No previous staff list found for URL {monitored_url_id}")
            return []

    except Exception as e:
        logger.error(f"Error retrieving previous staff list for URL {monitored_url_id}: {str(e)}")
        return []

def store_staff_list(monitored_url_id, staff_list):
    """Store the current staff list for future comparison."""
    try:
        import hashlib
        import json

        # Create content hash for the staff list
        staff_json = json.dumps(staff_list, sort_keys=True)
        content_hash = hashlib.sha256(staff_json.encode()).hexdigest()

        # Create new snapshot record
        snapshot = StaffListSnapshot(
            monitored_url_id=monitored_url_id,
            staff_data=staff_list,
            content_hash=content_hash
        )

        db.session.add(snapshot)

        # Clean up old snapshots (keep only the last 10 for each URL)
        old_snapshots = StaffListSnapshot.query.filter_by(
            monitored_url_id=monitored_url_id
        ).order_by(StaffListSnapshot.created_at.desc()).offset(10).all()

        for old_snapshot in old_snapshots:
            db.session.delete(old_snapshot)

        logger.debug(f"Stored staff list snapshot for URL {monitored_url_id}")

    except Exception as e:
        logger.error(f"Error storing staff list for URL {monitored_url_id}: {str(e)}")

def cleanup_old_logs():
    """Clean up old scraping logs to prevent database bloat."""
    with app.app_context():
        try:
            # Keep only logs from the last 30 days
            cutoff_date = datetime.utcnow() - timedelta(days=30)

            old_logs = ScrapingLog.query.filter(ScrapingLog.scraped_at < cutoff_date).all()

            for log in old_logs:
                db.session.delete(log)

            db.session.commit()
            logger.info(f"Cleaned up {len(old_logs)} old scraping logs")

        except Exception as e:
            logger.error(f"Error cleaning up old logs: {str(e)}")
            db.session.rollback()

def trigger_immediate_check(url_id):
    """Trigger an immediate check of a specific URL."""
    with app.app_context():
        monitored_url = MonitoredURL.query.get(url_id)
        if monitored_url:
            monitor_single_url(monitored_url)
            db.session.commit()
            return True
    return False
