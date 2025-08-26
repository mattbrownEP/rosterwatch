#!/usr/bin/env python3
"""
Script to backup production database before migrations.
Creates a complete SQL dump of the current production state.

Run from project root: python migrations/scripts/backup_production_database.py
"""

import os
import subprocess
import psycopg2
from datetime import datetime
from urllib.parse import urlparse

def get_db_connection_info():
    """Extract connection info from DATABASE_URL"""
    database_url = os.environ.get('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in environment")
        return None
    
    parsed = urlparse(database_url)
    return {
        'host': parsed.hostname,
        'port': parsed.port or 5432,
        'database': parsed.path[1:],  # Remove leading slash
        'username': parsed.username,
        'password': parsed.password
    }

def test_connection():
    """Test database connection"""
    database_url = os.environ.get('DATABASE_URL')
    if not database_url:
        return False
    
    try:
        conn = psycopg2.connect(database_url)
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM monitored_url;")
        count = cursor.fetchone()[0]
        print(f"✅ Connected to database - {count} URLs currently in production")
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False

def create_backup():
    """Create SQL backup of production database"""
    if not test_connection():
        return False
    
    # Get connection info
    db_info = get_db_connection_info()
    if not db_info:
        return False
    
    # Create backup filename with timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_filename = f"migrations/data/production_backup_{timestamp}.sql"
    
    # Ensure data directory exists
    os.makedirs(os.path.dirname(backup_filename), exist_ok=True)
    
    try:
        # Set password as environment variable for pg_dump
        env = os.environ.copy()
        env['PGPASSWORD'] = db_info['password']
        
        # Create pg_dump command
        pg_dump_cmd = [
            'pg_dump',
            '-h', db_info['host'],
            '-p', str(db_info['port']),
            '-U', db_info['username'],
            '-d', db_info['database'],
            '--no-password',
            '--verbose',
            '--clean',
            '--create'
        ]
        
        print(f"Creating backup: {backup_filename}")
        print("Running pg_dump...")
        
        # Execute pg_dump and save to file
        with open(backup_filename, 'w') as backup_file:
            result = subprocess.run(
                pg_dump_cmd,
                stdout=backup_file,
                stderr=subprocess.PIPE,
                env=env,
                text=True
            )
        
        if result.returncode == 0:
            # Get file size
            file_size = os.path.getsize(backup_filename)
            file_size_mb = file_size / (1024 * 1024)
            
            print(f"✅ Backup created successfully!")
            print(f"   File: {backup_filename}")
            print(f"   Size: {file_size_mb:.2f} MB")
            return backup_filename
        else:
            print(f"❌ pg_dump failed: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Backup failed: {e}")
        return False

def create_simple_backup():
    """Create a simple SQL backup using Python if pg_dump is not available"""
    database_url = os.environ.get('DATABASE_URL')
    if not database_url:
        return False
    
    try:
        conn = psycopg2.connect(database_url)
        cursor = conn.cursor()
        
        # Create backup filename with timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_filename = f"migrations/data/production_backup_simple_{timestamp}.sql"
        
        # Ensure data directory exists
        os.makedirs(os.path.dirname(backup_filename), exist_ok=True)
        
        with open(backup_filename, 'w') as backup_file:
            backup_file.write(f"-- Production database backup created on {datetime.now()}\n")
            backup_file.write(f"-- Simple backup using Python script\n\n")
            
            # Backup monitored_url table
            cursor.execute("SELECT * FROM monitored_url ORDER BY id;")
            rows = cursor.fetchall()
            
            # Get column names
            cursor.execute("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name = 'monitored_url' 
                ORDER BY ordinal_position;
            """)
            columns = [row[0] for row in cursor.fetchall()]
            
            backup_file.write("-- Backup of monitored_url table\n")
            backup_file.write("DELETE FROM monitored_url;\n\n")
            
            for row in rows:
                values = []
                for value in row:
                    if value is None:
                        values.append('NULL')
                    elif isinstance(value, str):
                        # Escape single quotes
                        escaped = value.replace("'", "''")
                        values.append(f"'{escaped}'")
                    elif isinstance(value, bool):
                        values.append('true' if value else 'false')
                    else:
                        values.append(str(value))
                
                values_str = ', '.join(values)
                backup_file.write(f"INSERT INTO monitored_url ({', '.join(columns)}) VALUES ({values_str});\n")
            
            # Count other tables
            cursor.execute("SELECT COUNT(*) FROM staff_change;")
            changes_count = cursor.fetchone()[0]
            cursor.execute("SELECT COUNT(*) FROM scraping_log;")
            logs_count = cursor.fetchone()[0]
            
            backup_file.write(f"\n-- Additional table counts:\n")
            backup_file.write(f"-- staff_change: {changes_count} records\n")
            backup_file.write(f"-- scraping_log: {logs_count} records\n")
        
        cursor.close()
        conn.close()
        
        file_size = os.path.getsize(backup_filename)
        file_size_kb = file_size / 1024
        
        print(f"✅ Simple backup created successfully!")
        print(f"   File: {backup_filename}")
        print(f"   Size: {file_size_kb:.2f} KB")
        print(f"   URLs backed up: {len(rows)}")
        
        return backup_filename
        
    except Exception as e:
        print(f"❌ Simple backup failed: {e}")
        return False

if __name__ == "__main__":
    print("🔄 Starting production database backup...")
    print(f"Timestamp: {datetime.now()}")
    print()
    
    # Try pg_dump first, fall back to simple backup
    backup_file = create_backup()
    if not backup_file:
        print("pg_dump not available or failed, trying simple backup...")
        backup_file = create_simple_backup()
    
    if backup_file:
        print(f"\n✅ Production database backed up successfully!")
        print(f"Backup saved to: {backup_file}")
        print("\nYou can now proceed with migrations safely.")
    else:
        print(f"\n❌ Backup failed!")
        print("Do not proceed with migrations without a backup.")