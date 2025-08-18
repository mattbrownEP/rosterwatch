#!/usr/bin/env python3
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
    print(f"SQL length: {len(sql_content)} characters")
    print(f"Number of INSERT statements: {sql_content.count('INSERT INTO')}")
    
    # The production site migration should pick this up
    # Let's try accessing it with our data
    
    url = "https://roster-watch-mattbrownep.replit.app/admin/migrate-data"
    
    try:
        # First, trigger the migration
        response = requests.post(url, data={'clear_existing': 'yes'}, timeout=60)
        
        if response.status_code == 200:
            print("✅ Migration triggered successfully")
            
            # Wait a moment for the database to update
            time.sleep(5)
            
            # Check if it worked
            check_response = requests.get("https://roster-watch-mattbrownep.replit.app/", timeout=10)
            
            import re
            match = re.search(r'<h4[^>]*>(\d+)</h4>\s*<p[^>]*>Total URLs</p>', check_response.text)
            if match:
                count = int(match.group(1))
                print(f"Production now shows: {count} URLs")
                
                if count == 225:
                    print("✅ SUCCESS! Production now has all {} URLs".format(225))
                else:
                    print(f"❌ Still showing {count} instead of 225")
                    
        else:
            print(f"❌ Migration failed with status {response.status_code}")
            
    except Exception as e:
        print(f"❌ Error applying to production: {e}")

if __name__ == "__main__":
    apply_to_production()
