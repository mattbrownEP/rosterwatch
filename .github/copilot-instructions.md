# Copilot Instructions for Staff Directory Monitor

## Project Overview
- **Purpose:** Monitors 225+ college athletic staff directories for changes, sending email alerts and supporting Open Records Requests.
- **Stack:** Python (Flask, SQLAlchemy, APScheduler), Bootstrap 5, SQLite (dev) / PostgreSQL (prod), BeautifulSoup4, Requests, SMTP for email.

## Architecture & Key Components
- `main.py` / `app.py`: App entry and Flask initialization.
- `models.py`: SQLAlchemy models: `MonitoredURL`, `StaffChange`, `ScrapingLog`.
- `scraper.py`: Scrapes staff directories, uses SHA-256 hashing for change detection, retries with exponential backoff, user-agent spoofing.
- `scheduler_service.py`: Runs APScheduler jobs every 30 minutes for monitoring, daily cleanup of logs.
- `email_service.py`: Sends HTML email notifications via SMTP, config via environment variables.
- `routes.py`: Flask routes for dashboard, admin, and API endpoints.
- `state_info.py`: State-specific config and URLs.
- `templates/`, `static/`: Bootstrap-based UI, dark theme, Font Awesome icons.

## Developer Workflows
- **Run locally:** `python main.py` (requires env vars for DB and SMTP)
- **Install deps:** `pip install flask flask-sqlalchemy apscheduler beautifulsoup4 requests gunicorn`
- **Environment:** Set `DATABASE_URL`, SMTP vars, `SESSION_SECRET` before running.
- **Access UI:** http://localhost:5000
- **Debugging:** Debug-level logging is enabled; errors are logged, not fatal.
- **Production:** Use PostgreSQL via `DATABASE_URL`. Connection pooling is configured for reliability.

## Project-Specific Patterns
- **Change detection:** Uses content hashing, not full page diffs, for efficiency.
- **Scraping:** Retry with exponential backoff; logs all failures in `ScrapingLog`.
- **Email:** HTML templates, all config via env vars.
- **Admin tools:** Web UI for managing URLs, testing scraping, and configuring notifications.
- **State browser:** Filter institutions by state in dashboard.

## Integration & External Dependencies
- **SMTP:** Supports Gmail, Outlook, custom SMTP via env vars.
- **Database:** SQLite (dev), PostgreSQL (prod); switch via `DATABASE_URL`.
- **Web scraping:** Requests + BeautifulSoup4; user-agent spoofing to avoid blocks.

## Examples & Conventions
- **Models:** See `models.py` for SQLAlchemy patterns.
- **Scheduler:** See `scheduler_service.py` for APScheduler job setup.
- **Scraper:** See `scraper.py` for retry and hashing logic.
- **Email:** See `email_service.py` for SMTP integration and HTML email formatting.
- **Routes:** All Flask endpoints in `routes.py`.

## Notes
- **Do not store sensitive info in code**; use environment variables for all secrets.
- **Production deployment** may require troubleshooting platform-specific issues (see `replit.md`).

---
If any section is unclear or missing, please provide feedback for further refinement.
