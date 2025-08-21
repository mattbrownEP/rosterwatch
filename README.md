# Staff Directory Monitor

A Flask-based web application that monitors college athletic department staff directories for changes and sends email notifications. Designed to help administrators quickly identify staff changes for filing Open Records Requests to obtain contract information.

## Features

- **Automated Monitoring**: Monitors 225+ college athletic staff directories every 30 minutes
- **Change Detection**: Automatically detects staff additions, removals, and modifications
- **Email Notifications**: Sends formatted email alerts when changes are detected
- **Web Dashboard**: Browse changes by state, view history, manage monitored URLs
- **Open Records Workflow**: Specialized workflow for filing contract information requests

## Tech Stack

- **Backend**: Python Flask, SQLAlchemy, APScheduler
- **Frontend**: Bootstrap 5 with Replit's dark theme
- **Database**: PostgreSQL (production) / SQLite (development)
- **Web Scraping**: BeautifulSoup4, Requests with retry logic
- **Email**: SMTP integration supporting Gmail and other providers

## Quick Start

1. **Install Dependencies**:
   ```bash
   pip install flask flask-sqlalchemy apscheduler beautifulsoup4 requests gunicorn
   ```

2. **Set Environment Variables**:
   ```bash
   export DATABASE_URL="your_database_url"
   export SMTP_SERVER="smtp.gmail.com"
   export SMTP_PORT="587"
   export SMTP_USERNAME="your_email@gmail.com"
   export SMTP_PASSWORD="your_app_password"
   export FROM_EMAIL="your_email@gmail.com"
   export SESSION_SECRET="your_secret_key"
   ```

3. **Run the Application**:
   ```bash
   python main.py
   ```

4. **Access the Dashboard**:
   - Open `http://localhost:5000`
   - Browse monitored institutions by state
   - View change detection history
   - Test email notifications

## Project Structure

```
├── app.py              # Flask app initialization and database setup
├── main.py             # Application entry point
├── models.py           # Database models (MonitoredURL, StaffChange, ScrapingLog)
├── routes.py           # Web routes and dashboard endpoints
├── scraper.py          # Web scraping engine with retry logic
├── scheduler_service.py # Background job scheduler (APScheduler)
├── email_service.py    # Email notification system
├── state_info.py       # State-specific configuration and URLs
├── templates/          # HTML templates with Bootstrap styling
├── static/            # CSS, JS, and static assets
└── replit.md          # Project documentation and architecture notes
```

## Key Components

### Database Models

- **MonitoredURL**: Stores institution information and monitoring settings
- **StaffChange**: Records detected changes with timestamps and descriptions  
- **ScrapingLog**: Maintains audit trail of scraping operations

### Background Services

- **Scheduler**: Runs monitoring every 30 minutes using APScheduler
- **Scraper**: Uses BeautifulSoup4 to extract staff information and detect changes
- **Email Service**: Sends HTML-formatted change notifications via SMTP

### Web Interface

- **Dashboard**: Overview of monitored institutions and recent changes
- **State Browser**: Filter and browse institutions by state
- **Change History**: Detailed view of all detected staff changes
- **Admin Tools**: Manage URLs, test scraping, configure notifications

## Current Status

- **Development**: ✅ Fully operational with 225 institutions loaded
- **Features**: ✅ All monitoring, email, and admin features working
- **Production**: ⚠️ Deployment platform issues being resolved

## Use Case

This system was built specifically for administrators who need to:
1. **Monitor** college athletic staff directories for changes
2. **Detect** when new staff are hired or existing staff leave
3. **File** Open Records Requests quickly to obtain contract information
4. **Track** changes across multiple institutions efficiently

The automated monitoring ensures no staff changes are missed, enabling timely Open Records Requests for contract details.