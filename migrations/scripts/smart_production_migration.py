#!/usr/bin/env python3
"""
Smart production migration script that handles foreign key constraints.
Instead of deleting URLs, this script will:
1. Insert new URLs that don't exist
2. Update existing URLs if they've changed
3. Preserve all logs and staff changes

Run from project root: python migrations/scripts/smart_production_migration.py
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

def get_migration_data():
    """Load the 225 URLs from migration file"""
    current_dir = os.path.dirname(os.path.abspath(__file__))
    migrations_dir = os.path.dirname(current_dir)
    project_root = os.path.dirname(migrations_dir)
    migration_file = os.path.join(project_root, 'migrations', 'sql', '003_updated_migration_225_institutions.sql')
    
    print(f"Reading migration data from: {migration_file}")
    
    with open(migration_file, 'r') as f:
        migration_sql = f.read()
    
    # Parse INSERT statements to extract URL data
    urls_to_migrate = []
    for line in migration_sql.split('\n'):
        if line.strip().startswith('INSERT INTO monitored_url'):
            # Extract values from INSERT statement
            # INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Name', 'URL', 'Email', NULL, true, NOW());
            values_start = line.find('VALUES (') + 8
            values_end = line.rfind(');')
            values_str = line[values_start:values_end]
            
            # Parse the values (this is a simple parser for our specific format)
            parts = []
            current_part = ""
            in_quotes = False
            
            for char in values_str:
                if char == "'" and not in_quotes:
                    in_quotes = True
                elif char == "'" and in_quotes:
                    in_quotes = False
                    parts.append(current_part)
                    current_part = ""
                elif char == ',' and not in_quotes:
                    if current_part.strip() in ['NULL', 'true', 'false', 'NOW()']:
                        parts.append(current_part.strip())
                        current_part = ""
                elif in_quotes:
                    current_part += char
                elif char != ' ' and char != ',':
                    current_part += char
            
            # Add the last part
            if current_part.strip():
                parts.append(current_part.strip())
            
            if len(parts) >= 5:  # name, url, email, state, is_active
                urls_to_migrate.append({
                    'name': parts[0],
                    'url': parts[1], 
                    'email': parts[2],
                    'state': parts[3] if parts[3] != 'NULL' else None,
                    'is_active': parts[4] == 'true'
                })
    
    print(f"Parsed {len(urls_to_migrate)} URLs from migration file")
    return urls_to_migrate

def run_smart_migration():
    """Run the smart migration that preserves existing data"""
    conn = connect_to_production_db()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        
        # Check current state
        cursor.execute("SELECT COUNT(*) FROM monitored_url;")
        current_count = cursor.fetchone()[0]
        print(f"Current URLs in production: {current_count}")
        
        # Get existing URLs
        cursor.execute("SELECT name, url FROM monitored_url;")
        existing_urls = {row[1]: row[0] for row in cursor.fetchall()}  # url -> name mapping
        print(f"Found {len(existing_urls)} existing URLs")
        
        # Get migration data
        migration_urls = get_migration_data()
        
        # Analyze what needs to be done
        urls_to_add = []
        urls_to_update = []
        
        for url_data in migration_urls:
            url = url_data['url']
            if url in existing_urls:
                # Check if name needs updating
                if existing_urls[url] != url_data['name']:
                    urls_to_update.append(url_data)
            else:
                urls_to_add.append(url_data)
        
        print(f"URLs to add: {len(urls_to_add)}")
        print(f"URLs to update: {len(urls_to_update)}")
        
        # Add new URLs
        added_count = 0
        for url_data in urls_to_add:
            try:
                cursor.execute("""
                    INSERT INTO monitored_url (name, url, email, state, is_active, created_at) 
                    VALUES (%s, %s, %s, %s, %s, NOW())
                """, (url_data['name'], url_data['url'], url_data['email'], 
                     url_data['state'], url_data['is_active']))
                added_count += 1
                if added_count % 25 == 0:
                    print(f"Added {added_count} new URLs...")
            except Exception as e:
                print(f"Error adding URL {url_data['name']}: {e}")
        
        # Update existing URLs if needed
        updated_count = 0
        for url_data in urls_to_update:
            try:
                cursor.execute("""
                    UPDATE monitored_url 
                    SET name = %s, email = %s, state = %s, is_active = %s
                    WHERE url = %s
                """, (url_data['name'], url_data['email'], url_data['state'], 
                     url_data['is_active'], url_data['url']))
                updated_count += 1
            except Exception as e:
                print(f"Error updating URL {url_data['url']}: {e}")
        
        # Commit changes
        conn.commit()
        
        # Check final count
        cursor.execute("SELECT COUNT(*) FROM monitored_url;")
        final_count = cursor.fetchone()[0]
        
        print(f"\nMigration Summary:")
        print(f"- Started with: {current_count} URLs")
        print(f"- Added: {added_count} new URLs")
        print(f"- Updated: {updated_count} existing URLs")
        print(f"- Final count: {final_count} URLs")
        
        cursor.close()
        conn.close()
        
        return final_count >= 225
        
    except Exception as e:
        print(f"Migration failed: {e}")
        if conn:
            conn.rollback()
            conn.close()
        return False

if __name__ == "__main__":
    print("🔄 Starting smart production database migration...")
    print(f"Timestamp: {datetime.now()}")
    print()
    
    success = run_smart_migration()
    
    if success:
        print("\n✅ Smart migration completed successfully!")
        print("Production database now contains the complete dataset")
    else:
        print("\n❌ Migration failed")
        print("Check error messages above for details")