#!/usr/bin/env python3
"""
Full system scan to check all monitored URLs for scraping issues
and detect any changes across the entire system.
"""

import sys
import logging
from datetime import datetime
sys.path.append('.')

from app import app, db
from models import MonitoredURL, StaffChange
from scraper import StaffDirectoryScraper

# Configure logging
logging.basicConfig(level=logging.WARNING)  # Reduce noise during scan

def scan_all_schools():
    """Scan all active URLs and report on their status"""
    
    with app.app_context():
        # Get all active URLs
        urls = db.session.query(MonitoredURL).filter_by(is_active=True).order_by(MonitoredURL.name).all()
        
        print(f"🔍 Starting comprehensive scan of {len(urls)} schools...")
        print(f"Scan started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("=" * 80)
        
        scraper = StaffDirectoryScraper()
        
        # Tracking variables
        total_scanned = 0
        successful_scans = 0
        failed_scans = 0
        low_count_schools = []
        changed_schools = []
        error_schools = []
        
        for i, url_obj in enumerate(urls, 1):
            total_scanned += 1
            print(f"\n[{i:3d}/{len(urls)}] {url_obj.name}")
            print(f"         URL: {url_obj.url}")
            
            try:
                # Perform the scrape
                staff_list, content_hash = scraper.scrape_staff_directory(url_obj.url)
                
                if staff_list is not None:
                    staff_count = len(staff_list)
                    successful_scans += 1
                    
                    # Check for content changes
                    if url_obj.last_content_hash and url_obj.last_content_hash != content_hash:
                        changed_schools.append({
                            'name': url_obj.name,
                            'url': url_obj.url,
                            'staff_count': staff_count,
                            'old_hash': url_obj.last_content_hash[:10],
                            'new_hash': content_hash[:10]
                        })
                        print(f"         🔥 CHANGE DETECTED! Staff: {staff_count}")
                    else:
                        print(f"         ✅ No changes. Staff: {staff_count}")
                    
                    # Flag unusually low staff counts
                    if staff_count < 10:
                        low_count_schools.append({
                            'name': url_obj.name,
                            'url': url_obj.url,
                            'staff_count': staff_count,
                            'sample_staff': [s.get('name', 'Unknown')[:50] for s in staff_list[:3]]
                        })
                        print(f"         ⚠️  LOW COUNT WARNING: Only {staff_count} staff")
                
                else:
                    failed_scans += 1
                    error_schools.append({
                        'name': url_obj.name,
                        'url': url_obj.url,
                        'error': content_hash  # content_hash contains error message when staff_list is None
                    })
                    print(f"         ❌ SCRAPING FAILED: {content_hash}")
                    
            except Exception as e:
                failed_scans += 1
                error_schools.append({
                    'name': url_obj.name,
                    'url': url_obj.url,
                    'error': str(e)
                })
                print(f"         💥 EXCEPTION: {str(e)}")
        
        # Generate comprehensive report
        print("\n" + "=" * 80)
        print("COMPREHENSIVE SCAN RESULTS")
        print("=" * 80)
        
        print(f"\n📊 SUMMARY STATISTICS")
        print(f"   Total schools scanned: {total_scanned}")
        print(f"   Successful scans: {successful_scans}")
        print(f"   Failed scans: {failed_scans}")
        print(f"   Success rate: {(successful_scans/total_scanned)*100:.1f}%")
        
        # Report content changes
        print(f"\n🔥 CONTENT CHANGES DETECTED: {len(changed_schools)}")
        if changed_schools:
            for school in changed_schools:
                print(f"   • {school['name']} ({school['staff_count']} staff)")
                print(f"     Hash: {school['old_hash']}... → {school['new_hash']}...")
        else:
            print("   No content changes detected")
        
        # Report low staff count issues
        print(f"\n⚠️  LOW STAFF COUNT WARNINGS: {len(low_count_schools)}")
        if low_count_schools:
            print("   Schools with suspiciously low staff counts (possible scraping issues):")
            for school in low_count_schools:
                print(f"   • {school['name']}: {school['staff_count']} staff")
                print(f"     Sample: {', '.join(school['sample_staff'])}")
        else:
            print("   All schools have reasonable staff counts")
        
        # Report failures
        print(f"\n❌ SCRAPING FAILURES: {len(error_schools)}")
        if error_schools:
            print("   Schools that failed to scrape:")
            for school in error_schools:
                print(f"   • {school['name']}")
                print(f"     Error: {school['error'][:100]}...")
        else:
            print("   No scraping failures")
        
        # Recommendations
        print(f"\n💡 RECOMMENDATIONS")
        if low_count_schools:
            print(f"   • Investigate {len(low_count_schools)} schools with low staff counts")
            print("   • These may need custom scraping logic or different selectors")
        
        if error_schools:
            print(f"   • Fix {len(error_schools)} schools with scraping failures")
            print("   • Check for site structure changes or blocking")
        
        if not low_count_schools and not error_schools:
            print("   • System is operating optimally!")
            print("   • All schools are scraping correctly")
        
        print(f"\nScan completed at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("=" * 80)

if __name__ == "__main__":
    scan_all_schools()