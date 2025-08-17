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

class ScrapingLog(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    monitored_url_id = db.Column(db.Integer, db.ForeignKey('monitored_url.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)  # 'success', 'error'
    message = db.Column(db.Text)
    scraped_at = db.Column(db.DateTime, default=datetime.utcnow)
