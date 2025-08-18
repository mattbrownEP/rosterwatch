#!/usr/bin/env python3
"""
Production deployment test script
"""
import os
import sys

def test_production_environment():
    print("=== Production Environment Test ===")
    
    # Test environment variables
    print(f"DATABASE_URL: {'SET' if os.environ.get('DATABASE_URL') else 'NOT SET'}")
    print(f"SESSION_SECRET: {'SET' if os.environ.get('SESSION_SECRET') else 'NOT SET'}")
    
    try:
        # Test app import
        print("\n=== Testing App Import ===")
        from app import app, db
        print("✓ App and database imported successfully")
        
        # Test routes import
        import routes
        print("✓ Routes imported successfully")
        
        # Test route registration
        rules = list(app.url_map.iter_rules())
        print(f"✓ {len(rules)} routes registered")
        
        # Test database connection
        with app.app_context():
            try:
                db.engine.execute("SELECT 1")
                print("✓ Database connection working")
            except Exception as e:
                print(f"✗ Database connection failed: {e}")
        
        print("\n=== App should be ready for production ===")
        return True
        
    except Exception as e:
        print(f"✗ Error during testing: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    test_production_environment()