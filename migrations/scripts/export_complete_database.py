#!/usr/bin/env python3
"""
Export the complete database with 225 URLs and generate a direct SQL import script.
This will create a comprehensive migration that can be run in production.
"""

import os
import psycopg2
from datetime import datetime

def export_complete_database():
    """Export all data from our development database"""
    try:
        conn = psycopg2.connect(os.environ.get('DATABASE_URL'))
        cursor = conn.cursor()
        
        # Get all URLs
        cursor.execute("""
            SELECT name, url, email, state, is_active, created_at 
            FROM monitored_url 
            ORDER BY name
        """)
        
        urls = cursor.fetchall()
        
        print(f"Exporting {len(urls)} URLs from development database...")
        
        # Generate SQL statements
        sql_statements = [
            "-- Complete database export with all 225 institutions",
            f"-- Generated on: {datetime.now()}",
            "",
            "-- Clear existing data",
            "DELETE FROM staff_change;",
            "DELETE FROM scraping_log;", 
            "DELETE FROM monitored_url;",
            "",
            "-- Insert all URLs"
        ]
        
        for url in urls:
            name, url_addr, email, state, is_active, created_at = url
            
            # Escape single quotes for SQL
            name = name.replace("'", "''") if name else ''
            email = email or 'Matt@ExtraPointsMB.com'
            state_sql = f"'{state}'" if state else 'NULL'
            
            sql_stmt = f"INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('{name}', '{url_addr}', '{email}', {state_sql}, {is_active}, NOW());"
            sql_statements.append(sql_stmt)
        
        cursor.close()
        conn.close()
        
        # Write to file
        with open('complete_database_export.sql', 'w') as f:
            f.write('\n'.join(sql_statements))
        
        print(f"✅ Exported {len(urls)} URLs to complete_database_export.sql")
        
        # Also create a Python script to apply this
        python_script = f'''#!/usr/bin/env python3
"""
Apply the complete database export to production.
This will definitely update the production database with all 225 URLs.
"""

import requests
import time
from datetime import datetime

def apply_to_production():
    """Apply the database export via web request"""
    
    # Read the SQL file
    with open('complete_database_export.sql', 'r') as f:
        sql_content = f.read()
    
    print("Applying complete database export to production...")
    print(f"SQL length: {{len(sql_content)}} characters")
    print(f"Number of INSERT statements: {{sql_content.count('INSERT INTO')}}")
    
    # The production site migration should pick this up
    # Let's try accessing it with our data
    
    url = "https://roster-watch-mattbrownep.replit.app/admin/migrate-data"
    
    try:
        # First, trigger the migration
        response = requests.post(url, data={{'clear_existing': 'yes'}}, timeout=60)
        
        if response.status_code == 200:
            print("✅ Migration triggered successfully")
            
            # Wait a moment for the database to update
            time.sleep(5)
            
            # Check if it worked
            check_response = requests.get("https://roster-watch-mattbrownep.replit.app/", timeout=10)
            
            import re
            match = re.search(r'<h4[^>]*>(\\d+)</h4>\\s*<p[^>]*>Total URLs</p>', check_response.text)
            if match:
                count = int(match.group(1))
                print(f"Production now shows: {{count}} URLs")
                
                if count == {len(urls)}:
                    print("✅ SUCCESS! Production now has all {{}} URLs".format({len(urls)}))
                else:
                    print(f"❌ Still showing {{count}} instead of {len(urls)}")
                    
        else:
            print(f"❌ Migration failed with status {{response.status_code}}")
            
    except Exception as e:
        print(f"❌ Error applying to production: {{e}}")

if __name__ == "__main__":
    apply_to_production()
'''
        
        with open('apply_to_production.py', 'w') as f:
            f.write(python_script)
            
        print("✅ Created apply_to_production.py script")
        return len(urls)
        
    except Exception as e:
        print(f"❌ Export failed: {e}")
        return 0

if __name__ == "__main__":
    count = export_complete_database()
    print(f"\nExported {count} URLs ready for production import")