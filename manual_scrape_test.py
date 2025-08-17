#!/usr/bin/env python3
"""
Manual scrape test to verify monitoring system functionality
"""

import sys
import os
import logging
from datetime import datetime, timedelta

# Add the current directory to the Python path
sys.path.append('.')

from app import app, db
from models import MonitoredURL, StaffChange, ScrapingLog
from scheduler_service import monitor_single_url
from scraper import StaffDirectoryScraper

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def test_scrape_schools():
    """Test scraping on several schools that haven't been checked recently"""
    
    with app.app_context():
        # Get schools that haven't been checked for over 10 hours
        schools_to_test = db.session.query(MonitoredURL).filter(
            MonitoredURL.last_checked < datetime.now() - timedelta(hours=10),
            MonitoredURL.is_active == True
        ).order_by(MonitoredURL.last_checked.asc()).limit(8).all()
        
        logger.info(f"Testing {len(schools_to_test)} schools for changes...")
        
        changes_found = 0
        errors = 0
        scraper = StaffDirectoryScraper()
        
        for school in schools_to_test:
            logger.info(f"\n--- Testing {school.name} ---")
            logger.info(f"URL: {school.url}")
            logger.info(f"Last checked: {school.last_checked}")
            
            try:
                # Store old hash and change count for comparison
                old_hash = school.last_content_hash
                old_change_count = db.session.query(StaffChange).filter_by(monitored_url_id=school.id).count()
                
                # Run the monitor function (this will scrape and detect changes)
                monitor_single_url(school)
                db.session.commit()
                
                # Check results
                school_updated = db.session.query(MonitoredURL).get(school.id)
                new_change_count = db.session.query(StaffChange).filter_by(monitored_url_id=school.id).count()
                
                logger.info(f"✓ Scrape completed for {school.name}")
                
                if school_updated.last_content_hash != old_hash:
                    logger.info(f"🔥 CONTENT CHANGE DETECTED at {school.name}!")
                    if new_change_count > old_change_count:
                        new_changes = new_change_count - old_change_count
                        changes_found += new_changes
                        logger.info(f"  {new_changes} NEW CHANGES recorded!")
                        
                        # Get the recent changes
                        recent_changes = db.session.query(StaffChange).filter(
                            StaffChange.monitored_url_id == school.id
                        ).order_by(StaffChange.detected_at.desc()).limit(new_changes).all()
                        
                        for change in recent_changes:
                            logger.info(f"    - {change.change_type}: {change.staff_name} ({change.staff_title})")
                    else:
                        logger.info(f"  Content hash changed but no staff changes detected")
                else:
                    logger.info(f"  No changes detected (hash unchanged)")
                    
            except Exception as e:
                logger.error(f"✗ Exception during scrape of {school.name}: {str(e)}")
                errors += 1
                db.session.rollback()
        
        logger.info(f"\n=== SUMMARY ===")
        logger.info(f"Schools tested: {len(schools_to_test)}")
        logger.info(f"Staff changes found: {changes_found}")
        logger.info(f"Errors: {errors}")
        
        return changes_found > 0

if __name__ == "__main__":
    test_scrape_schools()