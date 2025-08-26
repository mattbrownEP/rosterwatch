#!/usr/bin/env python3
"""
Script to properly migrate data to production database.
This will run the SQL commands directly against the production database.

Uses: migrations/sql/003_updated_migration_225_institutions.sql
Run from project root: python migrations/scripts/fix_production_database.py
"""

import os
import psycopg2
from datetime import datetime

def connect_to_production_db():
    """Connect to production database using DATABASE_URL"""
    database_url = os.environ.get('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in environment")
        return None
    
    try:
        conn = psycopg2.connect(database_url)
        return conn
    except Exception as e:
        print(f"Failed to connect to database: {e}")
        return None

def run_migration():
    """Run the complete migration script"""
    conn = connect_to_production_db()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        
        # Check current count
        cursor.execute("SELECT COUNT(*) FROM monitored_url;")
        current_count = cursor.fetchone()[0]
        print(f"Current URLs in production: {current_count}")
        
        # Clear existing monitored URLs only (preserve logs and staff changes)
        print("Clearing existing monitored URLs...")
        cursor.execute("DELETE FROM monitored_url;")
        
        # Read migration data from file
        print("Reading migration data...")
        # Get the project root directory (two levels up from this script)
        current_dir = os.path.dirname(os.path.abspath(__file__))  # migrations/scripts/
        migrations_dir = os.path.dirname(current_dir)  # migrations/
        project_root = os.path.dirname(migrations_dir)  # project root
        migration_file = os.path.join(project_root, 'migrations', 'sql', '003_updated_migration_225_institutions.sql')
        
        print(f"Looking for migration file at: {migration_file}")
        with open(migration_file, 'r') as f:
            migration_sql = f.read()
        
        # Extract only INSERT statements
        insert_statements = []
        for line in migration_sql.split('\n'):
            if line.strip().startswith('INSERT INTO monitored_url'):
                insert_statements.append(line.strip())
        
        print(f"Found {len(insert_statements)} INSERT statements")
        
        # Execute each INSERT statement
        for i, statement in enumerate(insert_statements):
            try:
                cursor.execute(statement)
                if (i + 1) % 50 == 0:
                    print(f"Inserted {i + 1} URLs...")
            except Exception as e:
                print(f"Error inserting statement {i + 1}: {e}")
                print(f"Statement: {statement}")
        
        # Commit changes
        conn.commit()
        
        # Check final count
        cursor.execute("SELECT COUNT(*) FROM monitored_url;")
        final_count = cursor.fetchone()[0]
        print(f"Final URLs in production: {final_count}")
        
        cursor.close()
        conn.close()
        
        return final_count == 225
        
    except Exception as e:
        print(f"Migration failed: {e}")
        if conn:
            conn.rollback()
            conn.close()
        return False

if __name__ == "__main__":
    print("Starting production database migration...")
    print(f"Timestamp: {datetime.now()}")
    
    success = run_migration()
    
    if success:
        print("✅ Migration completed successfully!")
        print("Production database now has 225 URLs")
    else:
        print("❌ Migration failed")