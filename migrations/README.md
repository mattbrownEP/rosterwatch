# Database Migrations

This folder contains all database migration files and scripts for the Staff Directory Monitor application.

## Folder Structure

```
migrations/
├── sql/           # SQL migration files
├── scripts/       # Python migration utilities
├── data/          # Migration data files
└── README.md      # This file
```

## SQL Migrations (`sql/`)

**001_complete_database_export_225_institutions.sql**
- Complete database export with all 225 institutions
- Generated on: 2025-08-18 01:14:07
- Contains INSERT statements for all monitored URLs

**002_database_migration_110_institutions.sql** 
- Earlier migration script with 110 institutions
- Historical version before expansion to 225
- Contains timestamped INSERT statements

**003_updated_migration_225_institutions.sql**
- Updated migration script with 225 institutions  
- Generated on: 2025-08-18 00:38:46
- Uses NOW() for timestamps instead of hardcoded values

## Migration Scripts (`scripts/`)

**complete_database_export.py**
- Python script to generate complete database exports
- Creates SQL INSERT statements from current database state
- Used to create the 225-institution migration

**export_complete_database.py**
- Alternative export utility
- Exports database content for migration purposes

**fix_production_database.py**
- Production database repair script
- Handles data inconsistencies and fixes

## Data Files (`data/`)

**migration_data_complete.txt**
- Migration completion status tracker
- Contains metadata about completed migrations

## Usage

### To Apply a Migration

1. **For Production Deployment:**
   ```sql
   \i migrations/sql/001_complete_database_export_225_institutions.sql
   ```

2. **For Development Setup:**
   ```bash
   python migrations/scripts/complete_database_export.py
   ```

### To Generate New Migration

1. **Export Current State:**
   ```bash
   python migrations/scripts/export_complete_database.py
   ```

2. **Create Numbered Migration:**
   - Name: `004_description_of_changes.sql`
   - Include clear comments about what changed

## Migration History

- **v1**: Initial 110 institutions (August 2025)
- **v2**: Expanded to 225 institutions (August 18, 2025)
- **v3**: Production-ready with optimized timestamps

## Best Practices

1. **Always backup** before running migrations
2. **Test migrations** in development first
3. **Use descriptive names** with version numbers
4. **Include rollback scripts** when possible
5. **Document changes** in commit messages

## Current Status

- **Development**: ✅ Running 225 institutions successfully
- **Production**: ⚠️ Deployment platform issues being resolved
- **Migration Target**: Complete 225-institution dataset