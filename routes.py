import logging
import os
from datetime import datetime, timedelta
from flask import render_template, request, redirect, url_for, flash, jsonify
from urllib.parse import urlparse

from app import app, db
from models import MonitoredURL, StaffChange, ScrapingLog
from scraper import StaffDirectoryScraper
from scheduler_service import trigger_immediate_check
from email_service import EmailService
from open_records_service import OpenRecordsService
from state_info import classify_position_importance, estimate_contract_likelihood

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

    return render_template(
        'index.html',
        monitored_urls=monitored_urls,
        recent_changes=recent_changes,
        recent_logs=recent_logs
    )

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
        scraper = StaffDirectoryScraper(debug_mode=True)
        staff_list, content_hash, debug_info = scraper.scrape_staff_directory(url)

        if staff_list is None:
            flash(f'Failed to scrape the URL: {content_hash}', 'error')
            return render_template('add_url.html', debug_info=debug_info)

        if len(staff_list) == 0:
            flash('No staff members found on this page. Please check the URL or try a different page.', 'warning')

        # Get Open Records service for state detection
        open_records_service = OpenRecordsService()
        detected_state = open_records_service.get_institution_state_from_url(url)

        # Create new monitored URL
        monitored_url = MonitoredURL(
            name=name,
            url=url,
            email=email,
            last_content_hash=content_hash,
            state=detected_state,
            institution_type='public'  # Default assumption for college athletics
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

    return render_template(
        'view_changes.html',
        monitored_url=monitored_url,
        changes=changes
    )

@app.route('/test_email')
def test_email():
    """Test email configuration."""
    email_service = EmailService()

    if email_service.test_email_configuration():
        flash('Email configuration is working correctly.', 'success')
    else:
        flash('Email configuration test failed. Please check your SMTP settings.', 'error')

    return redirect(url_for('index'))

@app.route('/changes')
def changes_portal():
    """Staff changes browsing portal."""
    # Get filter parameters
    days = request.args.get('days', 30, type=int)
    change_type = request.args.get('type', '')
    priority = request.args.get('priority', '')
    institution = request.args.get('institution', '')
    search = request.args.get('search', '')

    # Build query with filters
    query = StaffChange.query

    # Date filter
    if days and days > 0:
        cutoff_date = datetime.utcnow() - timedelta(days=int(days))
        query = query.filter(StaffChange.detected_at >= cutoff_date)

    # Change type filter
    if change_type:
        query = query.filter(StaffChange.change_type == change_type)

    # Priority filter
    if priority:
        query = query.filter(StaffChange.position_importance == priority)

    # Institution filter
    if institution:
        query = query.join(MonitoredURL).filter(MonitoredURL.name.ilike(f'%{institution}%'))

    # Search filter
    if search:
        search_term = f'%{search}%'
        query = query.filter(
            db.or_(
                StaffChange.staff_name.ilike(search_term),
                StaffChange.staff_title.ilike(search_term),
                StaffChange.change_description.ilike(search_term)
            )
        )

    # Get results
    changes = query.order_by(StaffChange.detected_at.desc()).limit(100).all()

    # Classify changes that haven't been classified yet
    open_records_service = OpenRecordsService()
    for change in changes:
        if not change.position_importance:
            classification = open_records_service.classify_staff_change(
                change.staff_name, change.staff_title, change.change_type
            )
            change.position_importance = classification['position_importance']
            change.likely_contract_value = classification['contract_likelihood']

    db.session.commit()

    # Get summary statistics for all changes (not just filtered)
    all_changes = StaffChange.query.all()
    summary = open_records_service.get_dashboard_summary([{
        'position_importance': c.position_importance,
        'open_records_filed': c.open_records_filed,
        'open_records_status': c.open_records_status
    } for c in all_changes])

    # Get unique institutions for filter dropdown
    institutions = db.session.query(MonitoredURL.name).distinct().order_by(MonitoredURL.name).all()
    institutions = [inst[0] for inst in institutions]

    return render_template(
        'changes_portal.html',
        changes=changes,
        summary=summary,
        institutions=institutions,
        filters={
            'days': days,
            'type': change_type,
            'priority': priority,
            'institution': institution,
            'search': search
        }
    )

@app.route('/open_records')
def open_records_dashboard():
    """Open Records Request dashboard."""
    # Get all staff changes with classification
    changes = StaffChange.query.order_by(StaffChange.detected_at.desc()).limit(50).all()

    # Classify changes that haven't been classified yet
    open_records_service = OpenRecordsService()
    for change in changes:
        if not change.position_importance:
            classification = open_records_service.classify_staff_change(
                change.staff_name, change.staff_title, change.change_type
            )
            change.position_importance = classification['position_importance']
            change.likely_contract_value = classification['contract_likelihood']

    db.session.commit()

    # Get summary statistics
    summary = open_records_service.get_dashboard_summary([{
        'position_importance': c.position_importance,
        'open_records_filed': c.open_records_filed,
        'open_records_status': c.open_records_status
    } for c in changes])

    return render_template('open_records.html', changes=changes, summary=summary)

@app.route('/admin/scraper-debug', methods=['GET', 'POST'])
def scraper_debug():
    """Debug page for testing the scraper with different URLs and seeing detailed results."""
    url = request.form.get('url', request.args.get('url', ''))
    debug_info = None
    staff_list = []

    if url:
        try:
            # Create a scraper in debug mode
            scraper = StaffDirectoryScraper(debug_mode=True)
            staff_data, content_hash, debug_info = scraper.scrape_staff_directory(url)

            if staff_data:
                staff_list = staff_data
                flash(f"Successfully scraped {len(staff_data)} staff members.", "success")
            else:
                flash(f"Failed to scrape URL: {content_hash}", "danger")
        except Exception as e:
            flash(f"Error testing scraper: {str(e)}", "danger")
            logger.exception("Scraper debug error")

    return render_template(
        'scraper_debug.html',
        url=url,
        debug_info=debug_info,
        staff_list=staff_list
    )

@app.route('/admin/migrate-data', methods=['GET', 'POST'])
def migrate_data():
    """Admin page to migrate database data from development to production."""
    if request.method == 'POST':
        try:
            # Get current count
            current_count = db.session.query(MonitoredURL).count()

            # Clear existing data if requested
            if request.form.get('clear_existing') == 'yes':
                db.session.query(StaffChange).delete()
                db.session.query(ScrapingLog).delete()
                db.session.query(MonitoredURL).delete()
                db.session.commit()

            # Use the complete 225-institution dataset from our export module
            from complete_database_export import get_complete_migration_data
            migration_data = get_complete_migration_data()

            # Insert all URLs from our complete dataset
            for name, url, email, state in migration_data:
                # Check if URL already exists
                existing = db.session.query(MonitoredURL).filter_by(url=url).first()
                if not existing:
                    new_url = MonitoredURL(
                        name=name,
                        url=url,
                        email=email or 'Matt@ExtraPointsMB.com',
                        state=state if state else None,
                        is_active=True
                    )
                    db.session.add(new_url)

            db.session.commit()

            # Get final count
            final_count = db.session.query(MonitoredURL).count()

            flash(f'Migration successful! Updated from {current_count} to {final_count} URLs.', 'success')
            return redirect(url_for('index'))

        except Exception as e:
            db.session.rollback()
            app.logger.error(f"Migration error: {e}")
            flash(f'Migration failed: {str(e)}', 'error')

    # GET request - show migration page
    current_count = db.session.query(MonitoredURL).count()
    return render_template(
        'admin_migrate.html',
        current_count=current_count,
        total_available=current_count
    )

@app.route('/generate_request/<int:change_id>')
def generate_request(change_id):
    """Generate an Open Records Request for a specific staff change."""
    change = StaffChange.query.get_or_404(change_id)
    monitored_url = change.monitored_url

    open_records_service = OpenRecordsService()

    # Prepare change data
    change_data = {
        'staff_name': change.staff_name,
        'staff_title': change.staff_title,
        'change_type': change.change_type,
        'detected_at': change.detected_at,
        'position_importance': change.position_importance
    }

    # Prepare institution data
    institution_data = {
        'name': monitored_url.name,
        'state': monitored_url.state,
        'open_records_contact': monitored_url.open_records_contact
    }

    # Generate the request letter
    request_letter = open_records_service.generate_request_letter(change_data, institution_data)

    return render_template(
        'request_letter.html',
        change=change,
        monitored_url=monitored_url,
        request_letter=request_letter
    )

@app.route('/mark_filed/<int:change_id>')
def mark_filed(change_id):
    """Mark an Open Records Request as filed."""
    change = StaffChange.query.get_or_404(change_id)

    change.open_records_filed = True
    change.open_records_date = datetime.utcnow()
    change.open_records_status = 'pending'

    try:
        db.session.commit()
        flash(f'Marked Open Records Request as filed for {change.staff_name}.', 'success')
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error marking request as filed: {str(e)}")
        flash('Error updating request status.', 'error')

    return redirect(url_for('open_records_dashboard'))

@app.route('/update_institution/<int:url_id>', methods=['GET', 'POST'])
def update_institution(url_id):
    """Update institution information for better Open Records requests."""
    monitored_url = MonitoredURL.query.get_or_404(url_id)

    if request.method == 'POST':
        monitored_url.state = request.form.get('state', '').upper()
        monitored_url.institution_type = request.form.get('institution_type', 'public')
        monitored_url.conference = request.form.get('conference', '')
        monitored_url.open_records_contact = request.form.get('open_records_contact', '')
        monitored_url.open_records_email = request.form.get('open_records_email', '')
        monitored_url.response_time_days = int(request.form.get('response_time_days', 10))

        try:
            db.session.commit()
            flash(f'Updated institution information for {monitored_url.name}.', 'success')
            return redirect(url_for('index'))
        except Exception as e:
            db.session.rollback()
            logger.error(f"Error updating institution: {str(e)}")
            flash('Error updating institution information.', 'error')

    # Get state info for form
    from state_info import STATE_INFO

    return render_template(
        'update_institution.html',
        monitored_url=monitored_url,
        state_info=STATE_INFO
    )

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

    def get_state_name(state_code):
        """Get full state name from abbreviation."""
        from state_info import STATE_INFO
        if state_code and state_code in STATE_INFO:
            return STATE_INFO[state_code]['name']
        return 'Unknown'

    def get_priority_badge_class(importance):
        """Get Bootstrap badge class for priority level."""
        if importance == 'high':
            return 'bg-danger'
        elif importance == 'medium':
            return 'bg-warning'
        else:
            return 'bg-secondary'

    return dict(
        format_datetime=format_datetime,
        time_ago=time_ago,
        get_state_name=get_state_name,
        get_priority_badge_class=get_priority_badge_class
    )

# Test scenarios data (development only)
TEST_SCENARIOS = {
    1: {
        'name': 'Baseline Scenario',
        'description': 'Initial staff configuration with 8 staff members',
        'staff': [
            {'name': 'John Smith', 'title': 'Head Football Coach', 'department': 'Athletics'},
            {'name': 'Sarah Johnson', 'title': 'Athletic Director', 'department': 'Athletics'},
            {'name': 'Mike Davis', 'title': 'Assistant Football Coach', 'department': 'Athletics'},
            {'name': 'Lisa Brown', 'title': 'Basketball Coach', 'department': 'Athletics'},
            {'name': 'Tom Wilson', 'title': 'Facilities Manager', 'department': 'Athletics'},
            {'name': 'Amy Taylor', 'title': 'Academic Advisor', 'department': 'Athletics'},
            {'name': 'Chris Lee', 'title': 'Strength & Conditioning Coach', 'department': 'Athletics'},
            {'name': 'Jennifer Martinez', 'title': 'Sports Information Director', 'department': 'Athletics'}
        ]
    },
    2: {
        'name': 'Staff Addition',
        'description': 'Added 2 new staff members, removed 1',
        'staff': [
            {'name': 'John Smith', 'title': 'Head Football Coach', 'department': 'Athletics'},
            {'name': 'Sarah Johnson', 'title': 'Athletic Director', 'department': 'Athletics'},
            {'name': 'Mike Davis', 'title': 'Assistant Football Coach', 'department': 'Athletics'},
            {'name': 'Lisa Brown', 'title': 'Basketball Coach', 'department': 'Athletics'},
            # Removed Tom Wilson
            {'name': 'Amy Taylor', 'title': 'Academic Advisor', 'department': 'Athletics'},
            {'name': 'Chris Lee', 'title': 'Strength & Conditioning Coach', 'department': 'Athletics'},
            {'name': 'Jennifer Martinez', 'title': 'Sports Information Director', 'department': 'Athletics'},
            # New additions
            {'name': 'David Rodriguez', 'title': 'Assistant Athletic Director', 'department': 'Athletics'},
            {'name': 'Kelly Thompson', 'title': 'Equipment Manager', 'department': 'Athletics'}
        ]
    },
    3: {
        'name': 'Title Changes',
        'description': 'Several staff members got promotions and title changes',
        'staff': [
            {'name': 'John Smith', 'title': 'Head Football Coach', 'department': 'Athletics'},
            {'name': 'Sarah Johnson', 'title': 'Senior Athletic Director', 'department': 'Athletics'},  # Promoted
            {'name': 'Mike Davis', 'title': 'Associate Football Coach', 'department': 'Athletics'},  # Promoted
            {'name': 'Lisa Brown', 'title': 'Head Basketball Coach', 'department': 'Athletics'},  # Promoted
            {'name': 'Amy Taylor', 'title': 'Senior Academic Advisor', 'department': 'Athletics'},  # Promoted
            {'name': 'Chris Lee', 'title': 'Director of Strength & Conditioning', 'department': 'Athletics'},  # Promoted
            {'name': 'Jennifer Martinez', 'title': 'Sports Information Director', 'department': 'Athletics'},
            {'name': 'David Rodriguez', 'title': 'Assistant Athletic Director', 'department': 'Athletics'},
            {'name': 'Kelly Thompson', 'title': 'Equipment Manager', 'department': 'Athletics'}
        ]
    },
    4: {
        'name': 'Major Restructuring',
        'description': 'Significant changes: new hires, departures, and reorganization',
        'staff': [
            {'name': 'John Smith', 'title': 'Head Football Coach', 'department': 'Athletics'},
            # Sarah Johnson left
            {'name': 'Michael Anderson', 'title': 'Athletic Director', 'department': 'Athletics'},  # New hire
            {'name': 'Mike Davis', 'title': 'Associate Football Coach', 'department': 'Athletics'},
            {'name': 'Lisa Brown', 'title': 'Head Basketball Coach', 'department': 'Athletics'},
            {'name': 'Amy Taylor', 'title': 'Senior Academic Advisor', 'department': 'Athletics'},
            # Chris Lee left
            {'name': 'Jennifer Martinez', 'title': 'Communications Director', 'department': 'Athletics'},  # Title change
            {'name': 'David Rodriguez', 'title': 'Associate Athletic Director', 'department': 'Athletics'},  # Promoted
            {'name': 'Kelly Thompson', 'title': 'Operations Manager', 'department': 'Athletics'},  # Title change
            {'name': 'Rachel Green', 'title': 'Head Strength Coach', 'department': 'Athletics'},  # New hire
            {'name': 'Mark Johnson', 'title': 'Compliance Officer', 'department': 'Athletics'}  # New hire
        ]
    }
}

# Current scenario state (stored in memory for development)
current_test_scenario = 1

@app.route('/sample-college-directory')
def sample_college_directory():
    """Development-only test directory page with scenario switching."""
    # Only available in development
    if os.environ.get("REPLIT_DEPLOYMENT") == "1":
        return "Not available in production", 404

    global current_test_scenario
    scenario = TEST_SCENARIOS[current_test_scenario]

    return render_template(
        'sample_directory.html',
        scenario=scenario,
        current_scenario=current_test_scenario,
        all_scenarios=TEST_SCENARIOS
    )

@app.route('/sample-college-directory/switch/<int:scenario_id>')
def switch_test_scenario(scenario_id):
    """Switch to a different test scenario."""
    # Only available in development
    if os.environ.get("REPLIT_DEPLOYMENT") == "1":
        return "Not available in production", 404

    global current_test_scenario
    if scenario_id in TEST_SCENARIOS:
        current_test_scenario = scenario_id
        flash(f'Switched to scenario {scenario_id}: {TEST_SCENARIOS[scenario_id]["name"]}', 'success')
    else:
        flash('Invalid scenario ID', 'error')

    return redirect(url_for('sample_college_directory'))
