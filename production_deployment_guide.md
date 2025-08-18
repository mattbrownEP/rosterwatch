# Production Deployment Guide - 225 Institution Database

## Current Issue
The production deployment has only 84 URLs instead of your complete 225-institution database. The web-based migration is pulling from hardcoded data instead of your actual database.

## Solution: SQL Migration

### Step 1: Access Production Database Panel
1. Go to your Replit production deployment
2. Click on the "Database" tab/pane
3. This will open the production PostgreSQL database interface

### Step 2: Run the Complete Migration Script
Copy and paste the contents of `updated_migration_225.sql` into the database query panel and execute it.

**File location:** `updated_migration_225.sql` (contains all 225 institutions)

### Step 3: Verification
After running the SQL script:
1. Go to `https://roster-watch-mattbrownep.replit.app/`
2. The dashboard should show **225 URLs** instead of 84
3. Your colleagues will now have access to the complete institutional database

## Alternative: Direct Database Access
If you prefer, I can provide the SQL commands here:

```sql
-- Clear existing data
DELETE FROM monitored_url;
DELETE FROM staff_change;
DELETE FROM scraping_log;

-- Insert all 225 institutions
-- (See updated_migration_225.sql for complete list)
```

## Post-Migration Verification
- Dashboard shows 225 total URLs
- Monitoring system continues running every 30 minutes
- Colleagues can access full institutional coverage
- Open Records workflow available for all institutions

## Why This Happened
The web migration route had hardcoded data from an older version (84 URLs) instead of dynamically pulling from your current database (225 URLs). The SQL approach bypasses this issue completely.