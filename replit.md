# Staff Directory Monitor

## Overview

This is a Flask-based web application that monitors staff directory pages for changes and sends email notifications when modifications are detected. The system automatically scrapes specified URLs at regular intervals, detects changes in staff information (additions, removals, modifications), and alerts users via email. It features a web dashboard for managing monitored URLs, viewing change history, and testing email configurations.

**Status**: Development environment fully operational with 225 institutions loaded and working perfectly. Production deployment at https://workspace-mattbrownep.replit.app experiencing persistent 404 errors despite multiple deployment attempts and fixes. Local server confirmed working with complete 225-institution dataset. Critical for user's job requirements.

## User Preferences

Preferred communication style: Simple, everyday language.
Primary use case: Filing Open Records Requests for college athletic staff contract information.

## System Architecture

### Web Framework
- **Flask**: Chosen as the core web framework for its simplicity and flexibility in building the monitoring dashboard and API endpoints
- **SQLAlchemy**: Used as the ORM for database operations with support for multiple database backends
- **Bootstrap**: Frontend framework for responsive UI components with dark theme support

### Database Design
- **SQLite (default) with PostgreSQL support**: Uses SQLite for development/simple deployments, with configurable PostgreSQL support for production
- **Three main entities**:
  - `MonitoredURL`: Stores website information, monitoring status, and user email preferences
  - `StaffChange`: Records detected changes with timestamps and change descriptions
  - `ScrapingLog`: Maintains audit trail of scraping operations and error tracking

### Background Processing
- **APScheduler**: Implements background job scheduling for automated monitoring tasks
- **Interval-based monitoring**: Runs every 30 minutes to check all active URLs for changes
- **Automatic cleanup**: Daily job removes old scraping logs to prevent database bloat

### Web Scraping Engine
- **Requests + BeautifulSoup**: Handles HTTP requests and HTML parsing for extracting staff information
- **Content hashing**: Uses SHA-256 hashing to detect changes efficiently without storing full page content
- **Retry mechanism**: Implements exponential backoff for handling temporary network failures
- **User-agent spoofing**: Mimics browser requests to avoid bot detection

### Email Notification System
- **SMTP integration**: Configurable email service supporting Gmail and other SMTP providers
- **HTML email templates**: Sends formatted change notifications with detailed change descriptions
- **Environment-based configuration**: Email credentials and settings managed through environment variables

### Error Handling & Logging
- **Comprehensive logging**: Debug-level logging throughout the application for monitoring and troubleshooting
- **Graceful error handling**: Network failures and parsing errors are logged without crashing the monitoring process
- **Status tracking**: Maintains success/failure status for each scraping operation

## External Dependencies

### Core Python Libraries
- **Flask**: Web framework and routing
- **SQLAlchemy**: Database ORM and migrations
- **APScheduler**: Background job scheduling
- **Requests**: HTTP client for web scraping
- **BeautifulSoup4**: HTML parsing and content extraction

### Email Services
- **SMTP servers**: Configurable support for Gmail, Outlook, or custom SMTP providers
- **Environment variables**: `SMTP_SERVER`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `FROM_EMAIL`

### Database Support
- **SQLite**: Default embedded database for simple deployments
- **PostgreSQL**: Production database option via `DATABASE_URL` environment variable
- **Connection pooling**: Configured for production reliability with connection recycling

### Frontend Assets
- **Bootstrap CSS**: Replit's agent dark theme variant for consistent styling
- **Font Awesome**: Icon library for UI enhancement
- **CDN delivery**: External CSS and JavaScript assets loaded from CDNs

### Infrastructure Requirements
- **Environment variables**: Session secrets, database URLs, and SMTP configuration
- **File system**: Local storage for SQLite database in development mode
- **Network access**: Outbound HTTP/HTTPS for scraping target websites and sending emails

## Recent Changes (Aug 26, 2025)
- **Migration Organization**: ✅ All database migration files organized into `migrations/` folder structure
- **Migration Scripts**: ✅ Updated to reference correct file paths in new locations
- **Backup System**: ✅ Production database backup created and documented
- **Documentation**: ✅ Complete backup procedures and emergency restoration guides
- **Development**: ✅ Working perfectly with 225 institutions
- **Production deployment**: ❌ https://workspace-mattbrownep.replit.app shows 404 errors
- **Alternative production URL**: https://roster-watch-mattbrownep.replit.app (has 80 URLs, needs migration)
- **User requirement**: Urgent need for colleagues to access complete 225-institution database

## Migration & Backup Structure
```
migrations/
├── sql/                    # Numbered SQL migration files (001, 002, 003)
├── scripts/               # Python migration and backup utilities
├── data/                  # Migration data, status files, and database backups
├── README.md              # Migration overview and usage guide
└── BACKUP_PROCEDURES.md   # Complete backup documentation and emergency procedures
```

## Database Status (Aug 26, 2025)
- **Root Cause Found**: ✅ DATABASE_URL was pointing to old database version - corrected
- **Production Migration**: ✅ Successfully completed using smart migration approach
- **Final Result**: 225 URLs confirmed in production (80 existing + 145 new)
- **Latest Backup**: `production_backup_20250826_092301.sql` (actual production state)
- **Migration Method**: Used `migrations/scripts/smart_production_migration.py` 
- **Data Preservation**: All existing logs and staff changes maintained with foreign key integrity
- **Status**: ✅ Production database now contains complete 225-institution dataset with historical data intact

## Tomorrow's Options
1. **Fix current deployment**: Debug why workspace-mattbrownep.replit.app fails despite working locally
2. **Migrate existing production**: Update roster-watch-mattbrownep.replit.app from 80 to 225 URLs
3. **Alternative deployment**: Try different deployment approach or platform