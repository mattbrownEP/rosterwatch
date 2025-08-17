from datetime import datetime
from app import db

class MonitoredURL(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    url = db.Column(db.String(500), nullable=False)
    email = db.Column(db.String(120), nullable=False)
    last_checked = db.Column(db.DateTime, default=datetime.utcnow)
    last_content_hash = db.Column(db.String(64))
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Institution information
    state = db.Column(db.String(2))  # State abbreviation
    institution_type = db.Column(db.String(20), default='public')  # public/private
    conference = db.Column(db.String(100))
    open_records_contact = db.Column(db.String(200))
    open_records_email = db.Column(db.String(120))
    response_time_days = db.Column(db.Integer, default=10)  # Typical response time
    
    # Relationship to changes
    changes = db.relationship('StaffChange', backref='monitored_url', lazy=True, cascade='all, delete-orphan')

class StaffChange(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    monitored_url_id = db.Column(db.Integer, db.ForeignKey('monitored_url.id'), nullable=False)
    change_type = db.Column(db.String(50), nullable=False)  # 'added', 'removed', 'modified'
    staff_name = db.Column(db.String(200))
    staff_title = db.Column(db.String(200))
    change_description = db.Column(db.Text)
    detected_at = db.Column(db.DateTime, default=datetime.utcnow)
    email_sent = db.Column(db.Boolean, default=False)
    
    # Enhanced tracking for Open Records requests
    position_importance = db.Column(db.String(20), default='standard')  # 'high', 'medium', 'standard'
    likely_contract_value = db.Column(db.String(20))  # 'high', 'medium', 'low', 'none'
    open_records_filed = db.Column(db.Boolean, default=False)
    open_records_date = db.Column(db.DateTime)
    open_records_status = db.Column(db.String(50), default='not_filed')  # 'not_filed', 'pending', 'received', 'denied'

class ScrapingLog(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    monitored_url_id = db.Column(db.Integer, db.ForeignKey('monitored_url.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)  # 'success', 'error'
    message = db.Column(db.Text)
    scraped_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationship to monitored URL
    monitored_url = db.relationship('MonitoredURL', backref='scraping_logs')
