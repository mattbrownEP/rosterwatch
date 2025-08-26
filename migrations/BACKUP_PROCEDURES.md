# Database Backup Procedures

This document outlines the backup procedures for the Staff Directory Monitor production database.

## Quick Backup Command

```bash
# Run from project root
python migrations/scripts/backup_production_database.py
```

## Backup Script Features

The backup script (`migrations/scripts/backup_production_database.py`) provides:

- **Automatic connection testing** - Verifies database connectivity before backup
- **Complete SQL dump** - Uses `pg_dump` for full PostgreSQL backup with schema and data
- **Fallback method** - Python-based backup if `pg_dump` is unavailable
- **Timestamped files** - Automatic filename with date/time stamp
- **File size reporting** - Shows backup file size and record counts
- **Error handling** - Clear error messages and graceful failure handling

## Backup File Locations

All backups are saved to: `migrations/data/`

**Naming Convention:**
- Full backup: `production_backup_YYYYMMDD_HHMMSS.sql`
- Simple backup: `production_backup_simple_YYYYMMDD_HHMMSS.sql`

## When to Create Backups

### Always backup before:
1. **Database migrations** - Any structural or data changes
2. **Production deployments** - Before deploying new versions
3. **Data imports** - Before importing new institution URLs
4. **Schema changes** - Before modifying table structures
5. **Major application updates** - Before significant code changes

### Recommended schedule:
- **Weekly** - Regular operational backups
- **Before any production changes** - Safety measure
- **After major data additions** - Preserve important updates

## Backup Contents

### Full Backup (pg_dump) includes:
- Complete database schema (tables, indexes, constraints, sequences)
- All table data (monitored_url, staff_change, scraping_log)
- User permissions and database settings
- Full restore capability

### Simple Backup includes:
- Complete monitored_url table data with all 225+ institutions
- Record counts for staff_change and scraping_log tables
- Basic restoration for URL data

## Restoration Procedures

### From Full Backup:
```bash
# Restore complete database (DESTRUCTIVE - replaces all data)
psql $DATABASE_URL < migrations/data/production_backup_YYYYMMDD_HHMMSS.sql
```

### From Simple Backup:
```bash
# Restore URL data only
psql $DATABASE_URL < migrations/data/production_backup_simple_YYYYMMDD_HHMMSS.sql
```

### Using Database Management Tools:
- Import the SQL file through your database administration interface
- Execute the SQL commands directly in your database client

## Verification Steps

After creating a backup:

1. **Check file size** - Should be > 0 KB and reasonable for your data volume
2. **Verify record counts** - Compare with current production counts
3. **Test restoration** - In development environment if possible
4. **Document backup** - Note backup purpose and any special circumstances

## Current Status (August 26, 2025)

**Latest Backup:**
- File: `production_backup_20250826_090121.sql`
- Size: 0.04 MB
- URLs: 225 institutions
- Status: ✅ Verified complete

**Production Database State:**
- URLs: 225 active monitoring targets
- Application: Fully operational in development
- Deployment: Production platform issues being resolved

## Backup Management

### Retention Policy:
- Keep **last 5 daily** backups
- Keep **last 4 weekly** backups  
- Keep **monthly** backups for 6 months
- Archive **major milestone** backups permanently

### Storage Considerations:
- Backup files are relatively small (< 1 MB typically)
- Store in version control for development backups
- Use secure external storage for production backup retention

## Emergency Procedures

### If backup fails:
1. Check database connectivity
2. Verify DATABASE_URL environment variable
3. Try simple backup method as fallback
4. Contact database administrator if all methods fail
5. **Do not proceed with risky operations without backup**

### If restoration needed:
1. **Stop all application processes** immediately
2. Create backup of current state (if accessible)
3. Restore from most recent backup
4. Verify data integrity after restoration
5. Restart application services
6. Test monitoring functionality

## Script Maintenance

The backup script should be reviewed and updated when:
- Database schema changes significantly
- New critical tables are added
- Production environment changes
- PostgreSQL version upgrades occur

## Contact Information

For backup-related issues:
- Check application logs for error details
- Verify environment variable configuration
- Consult database administrator for infrastructure issues
- Review migration documentation for context-specific procedures