#!/usr/bin/env python3
"""
Debug script to understand what's happening with the production deployment.
This will help us understand why the production site shows 80 URLs when database has 225.
"""

import requests
import os
import psycopg2
from datetime import datetime

def check_database_direct():
    """Check the database directly"""
    try:
        conn = psycopg2.connect(os.environ.get('DATABASE_URL'))
        cursor = conn.cursor()
        
        cursor.execute('SELECT COUNT(*) FROM monitored_url;')
        count = cursor.fetchone()[0]
        print(f"Database COUNT: {count}")
        
        cursor.execute('SELECT name FROM monitored_url ORDER BY name LIMIT 10;')
        urls = cursor.fetchall()
        print("First 10 URLs:")
        for url in urls:
            print(f"  - {url[0]}")
            
        cursor.close()
        conn.close()
        return count
        
    except Exception as e:
        print(f"Database check failed: {e}")
        return 0

def check_production_site():
    """Check what the production site actually shows"""
    try:
        response = requests.get("https://roster-watch-mattbrownep.replit.app/", timeout=10)
        html = response.text
        
        # Extract the number from "Total URLs"
        import re
        match = re.search(r'<h4[^>]*>(\d+)</h4>\s*<p[^>]*>Total URLs</p>', html)
        if match:
            site_count = int(match.group(1))
            print(f"Production site COUNT: {site_count}")
            return site_count
        else:
            print("Could not find Total URLs count on production site")
            return 0
            
    except Exception as e:
        print(f"Production site check failed: {e}")
        return 0

def main():
    print("=== PRODUCTION DEPLOYMENT DEBUG ===")
    print(f"Timestamp: {datetime.now()}")
    print()
    
    print("1. Checking database directly...")
    db_count = check_database_direct()
    print()
    
    print("2. Checking production website...")
    site_count = check_production_site()
    print()
    
    print("=== SUMMARY ===")
    print(f"Database has: {db_count} URLs")
    print(f"Website shows: {site_count} URLs")
    
    if db_count != site_count:
        print("❌ MISMATCH: Website is not reading from the updated database!")
        print("Possible causes:")
        print("- Production deployment using different DATABASE_URL")
        print("- Application caching the count")
        print("- Database connection pooling issue")
        print("- Production deployment hasn't restarted properly")
    else:
        print("✅ Database and website match!")

if __name__ == "__main__":
    main()