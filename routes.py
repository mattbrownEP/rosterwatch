import logging
from datetime import datetime, timedelta
from flask import render_template, request, redirect, url_for, flash, jsonify
from urllib.parse import urlparse

from app import app, db
from models import MonitoredURL, StaffChange, ScrapingLog
from scraper import StaffDirectoryScraper
from scheduler_service import trigger_immediate_check
from email_service import EmailService

logger = logging.getLogger(__name__)

@app.route('/')
def index():
    """Main dashboard showing all monitored URLs and recent changes."""
    monitored_urls = MonitoredURL.query.order_by(MonitoredURL.created_at.desc()).all()
    
    # Get recent changes (last 7 days)
    recent_changes = StaffChange.query.filter(
        StaffChange.detected_at >= datetime.utcnow() - timedelta(days=7)
    ).order_by(StaffChange.detected_at.desc()).limit(10).all()
    
    # Get recent logs
    recent_logs = ScrapingLog.query.order_by(ScrapingLog.scraped_at.desc()).limit(5).all()
    
    return render_template('index.html', 
                         monitored_urls=monitored_urls,
                         recent_changes=recent_changes,
                         recent_logs=recent_logs)

@app.route('/add_url', methods=['GET', 'POST'])
def add_url():
    """Add a new URL to monitor."""
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        url = request.form.get('url', '').strip()
        email = request.form.get('email', '').strip()
        
        # Validation
        if not name or not url or not email:
            flash('All fields are required.', 'error')
            return render_template('add_url.html')
        
        # Validate URL format
        parsed_url = urlparse(url)
        if not parsed_url.scheme or not parsed_url.netloc:
            flash('Please enter a valid URL (including http:// or https://).', 'error')
            return render_template('add_url.html')
        
        # Check if URL already exists
        existing_url = MonitoredURL.query.filter_by(url=url).first()
        if existing_url:
            flash('This URL is already being monitored.', 'error')
            return render_template('add_url.html')
        
        # Test scraping the URL
        scraper = StaffDirectoryScraper()
        staff_list, content_hash = scraper.scrape_staff_directory(url)
        
        if staff_list is None:
            flash(f'Failed to scrape the URL: {content_hash}', 'error')
            return render_template('add_url.html')
        
        if len(staff_list) == 0:
            flash('No staff members found on this page. Please check the URL or try a different page.', 'warning')
        
        # Create new monitored URL
        monitored_url = MonitoredURL(
            name=name,
            url=url,
            email=email,
            last_content_hash=content_hash
        )
        
        try:
            db.session.add(monitored_url)
            db.session.commit()
            
            # Log initial scraping
            log_entry = ScrapingLog(
                monitored_url_id=monitored_url.id,
                status='success',
                message=f'Initial scraping successful. Found {len(staff_list)} staff members.'
            )
            db.session.add(log_entry)
            db.session.commit()
            
            flash(f'Successfully added "{name}" to monitoring. Found {len(staff_list)} staff members.', 'success')
            return redirect(url_for('index'))
            
        except Exception as e:
            db.session.rollback()
            logger.error(f"Error adding URL: {str(e)}")
            flash('Error adding URL to database. Please try again.', 'error')
    
    return render_template('add_url.html')

@app.route('/toggle_url/<int:url_id>')
def toggle_url(url_id):
    """Toggle active status of a monitored URL."""
    monitored_url = MonitoredURL.query.get_or_404(url_id)
    monitored_url.is_active = not monitored_url.is_active
    
    try:
        db.session.commit()
        status = "activated" if monitored_url.is_active else "deactivated"
        flash(f'Successfully {status} monitoring for "{monitored_url.name}".', 'success')
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error toggling URL status: {str(e)}")
        flash('Error updating URL status.', 'error')
    
    return redirect(url_for('index'))

@app.route('/delete_url/<int:url_id>')
def delete_url(url_id):
    """Delete a monitored URL."""
    monitored_url = MonitoredURL.query.get_or_404(url_id)
    name = monitored_url.name
    
    try:
        db.session.delete(monitored_url)
        db.session.commit()
        flash(f'Successfully deleted "{name}" from monitoring.', 'success')
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error deleting URL: {str(e)}")
        flash('Error deleting URL.', 'error')
    
    return redirect(url_for('index'))

@app.route('/check_now/<int:url_id>')
def check_now(url_id):
    """Trigger immediate check of a specific URL."""
    monitored_url = MonitoredURL.query.get_or_404(url_id)
    
    try:
        success = trigger_immediate_check(url_id)
        if success:
            flash(f'Successfully checked "{monitored_url.name}". Check the logs for results.', 'success')
        else:
            flash(f'Error checking "{monitored_url.name}".', 'error')
    except Exception as e:
        logger.error(f"Error triggering immediate check: {str(e)}")
        flash('Error triggering check.', 'error')
    
    return redirect(url_for('index'))

@app.route('/view_changes/<int:url_id>')
def view_changes(url_id):
    """View all changes for a specific URL."""
    monitored_url = MonitoredURL.query.get_or_404(url_id)
    
    page = request.args.get('page', 1, type=int)
    per_page = 20
    
    changes = StaffChange.query.filter_by(monitored_url_id=url_id)\
                             .order_by(StaffChange.detected_at.desc())\
                             .paginate(page=page, per_page=per_page, error_out=False)
    
    return render_template('view_changes.html', 
                         monitored_url=monitored_url,
                         changes=changes)

@app.route('/test_email')
def test_email():
    """Test email configuration."""
    email_service = EmailService()
    
    if email_service.test_email_configuration():
        flash('Email configuration is working correctly.', 'success')
    else:
        flash('Email configuration test failed. Please check your SMTP settings.', 'error')
    
    return redirect(url_for('index'))

@app.context_processor
def utility_processor():
    """Add utility functions to Jinja2 templates."""
    def format_datetime(dt):
        if dt:
            return dt.strftime('%Y-%m-%d %H:%M UTC')
        return 'Never'
    
    def time_ago(dt):
        if not dt:
            return 'Never'
        
        now = datetime.utcnow()
        diff = now - dt
        
        if diff.total_seconds() < 60:
            return 'Just now'
        elif diff.total_seconds() < 3600:
            minutes = int(diff.total_seconds() / 60)
            return f'{minutes} minute{"s" if minutes != 1 else ""} ago'
        elif diff.total_seconds() < 86400:
            hours = int(diff.total_seconds() / 3600)
            return f'{hours} hour{"s" if hours != 1 else ""} ago'
        else:
            days = diff.days
            return f'{days} day{"s" if days != 1 else ""} ago'
    
    return dict(format_datetime=format_datetime, time_ago=time_ago)
