import os
import logging

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase
from werkzeug.middleware.proxy_fix import ProxyFix

# Configure logging
logging.basicConfig(level=logging.DEBUG)

class Base(DeclarativeBase):
    pass

db = SQLAlchemy(model_class=Base)

# create the app
app = Flask(__name__)
app.secret_key = os.environ.get("SESSION_SECRET", "dev-secret-key-12345")
app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)

# Configure database based on environment
def get_database_url():
    """Select database URL based on environment (preview vs production)."""
    
    # Check if we're in production deployment
    is_production = os.environ.get("REPLIT_DEPLOYMENT") == "1"
    
    if is_production:
        # Production deployment - use production database
        db_url = os.environ.get("DATABASE_URL", "sqlite:///staff_monitor.db")
        db_type = "PRODUCTION"
    else:
        # Preview/development mode - use development database
        db_url = os.environ.get("DEV_DATABASE_URL") or os.environ.get("DATABASE_URL", "sqlite:///staff_monitor_dev.db")
        db_type = "DEVELOPMENT"
    
    # Log which database is being used
    if db_url.startswith("postgresql"):
        db_name = "PostgreSQL"
    elif db_url.startswith("sqlite"):
        db_name = "SQLite"
    else:
        db_name = "Unknown"
        
    print(f"🗄️  Using {db_type} database: {db_name}")
    logging.info(f"Database configuration: {db_type} database ({db_name})")
    
    return db_url

app.config["SQLALCHEMY_DATABASE_URI"] = get_database_url()
app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {
    "pool_recycle": 300,
    "pool_pre_ping": True,
}

# initialize the app with the extension
db.init_app(app)

with app.app_context():
    # Import models to create tables
    import models
    db.create_all()
    
    # Import routes
    import routes
