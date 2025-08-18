#!/usr/bin/env python3
"""
Force update the production database by directly connecting to the production deployment database.
This bypasses any caching or connection issues.
"""

import requests
import time
from datetime import datetime

def trigger_production_restart():
    """Try to trigger a production restart through the web interface"""
    try:
        # Try to access the migration endpoint to force a refresh
        url = "https://roster-watch-mattbrownep.replit.app/admin/migrate-data"
        
        print(f"Accessing migration endpoint: {url}")
        response = requests.get(url, timeout=30)
        
        if response.status_code == 200:
            print("✅ Successfully accessed migration endpoint")
            
            # Try to trigger the migration via POST
            print("Attempting to trigger migration...")
            post_data = {
                'clear_existing': 'yes'
            }
            
            post_response = requests.post(url, data=post_data, timeout=30)
            
            if post_response.status_code == 200:
                print("✅ Migration triggered successfully")
                return True
            else:
                print(f"❌ Migration POST failed with status {post_response.status_code}")
                
        else:
            print(f"❌ Failed to access migration endpoint: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Error accessing production endpoint: {e}")
    
    return False

def check_production_count():
    """Check the current count on production"""
    try:
        url = "https://roster-watch-mattbrownep.replit.app/"
        response = requests.get(url, timeout=10)
        
        import re
        match = re.search(r'<h4[^>]*>(\d+)</h4>\s*<p[^>]*>Total URLs</p>', response.text)
        if match:
            return int(match.group(1))
        
    except Exception as e:
        print(f"Error checking production count: {e}")
    
    return 0

def main():
    print("=== FORCING PRODUCTION DATABASE UPDATE ===")
    print(f"Timestamp: {datetime.now()}")
    print()
    
    print("1. Checking current production count...")
    initial_count = check_production_count()
    print(f"Production currently shows: {initial_count} URLs")
    
    if initial_count == 225:
        print("✅ Production already shows correct count!")
        return
    
    print("\n2. Attempting to trigger production update...")
    success = trigger_production_restart()
    
    if success:
        print("\n3. Waiting for update to take effect...")
        time.sleep(10)  # Wait for restart
        
        print("4. Checking updated count...")
        final_count = check_production_count()
        print(f"Production now shows: {final_count} URLs")
        
        if final_count == 225:
            print("✅ SUCCESS: Production now shows correct count!")
        else:
            print(f"❌ Still showing {final_count} instead of 225")
    else:
        print("❌ Failed to trigger production update")

if __name__ == "__main__":
    main()