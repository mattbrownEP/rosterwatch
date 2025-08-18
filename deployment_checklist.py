#!/usr/bin/env python3
"""
Pre-deployment checklist to ensure production readiness.
Verifies database integrity and application configuration.
"""

import os
import psycopg2
from datetime import datetime

def check_deployment_readiness():
    """Check if the application is ready for production deployment"""
    print("=== DEPLOYMENT READINESS CHECK ===")
    print(f"Timestamp: {datetime.now()}")
    print()
    
    # Check database connection and count
    try:
        conn = psycopg2.connect(os.environ.get('DATABASE_URL'))
        cursor = conn.cursor()
        
        cursor.execute('SELECT COUNT(*) FROM monitored_url;')
        url_count = cursor.fetchone()[0]
        
        cursor.execute('SELECT COUNT(*) FROM monitored_url WHERE is_active = true;')
        active_count = cursor.fetchone()[0]
        
        print(f"✓ Database connection: OK")
        print(f"✓ Total URLs in database: {url_count}")
        print(f"✓ Active URLs: {active_count}")
        
        if url_count >= 225:
            print("✓ Database has complete dataset (225+ institutions)")
        else:
            print(f"❌ Database incomplete: only {url_count} URLs (need 225)")
            return False
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Database check failed: {e}")
        return False
    
    # Check environment variables
    required_env_vars = [
        'DATABASE_URL',
        'SESSION_SECRET',
        'SMTP_SERVER',
        'SMTP_USERNAME',
        'FROM_EMAIL'
    ]
    
    print("\n--- Environment Variables ---")
    all_env_ok = True
    for var in required_env_vars:
        if os.environ.get(var):
            print(f"✓ {var}: Set")
        else:
            print(f"❌ {var}: Missing")
            all_env_ok = False
    
    # Check application files
    print("\n--- Application Files ---")
    required_files = [
        'main.py',
        'app.py', 
        'routes.py',
        'models.py',
        'scheduler_service.py',
        'scraper.py',
        'complete_database_export.py'
    ]
    
    all_files_ok = True
    for file in required_files:
        if os.path.exists(file):
            print(f"✓ {file}: Present")
        else:
            print(f"❌ {file}: Missing")
            all_files_ok = False
    
    print(f"\n=== DEPLOYMENT STATUS ===")
    
    if url_count >= 225 and all_env_ok and all_files_ok:
        print("🎉 READY FOR DEPLOYMENT!")
        print("The application is configured correctly with the complete dataset.")
        print(f"Your colleagues will have access to all {url_count} institutions.")
        return True
    else:
        print("❌ NOT READY FOR DEPLOYMENT")
        print("Please fix the issues above before deploying.")
        return False

if __name__ == "__main__":
    ready = check_deployment_readiness()
    if ready:
        print("\n✓ You can now click the Deploy button in Replit to create a fresh production deployment.")
    else:
        print("\n❌ Please address the issues above before deployment.")