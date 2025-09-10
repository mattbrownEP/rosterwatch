import requests
import hashlib
import logging
import time
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from typing import List, Dict, Optional, Tuple

# === Centrally defined selectors for staff scraping ===
STAFF_CONTAINER_SELECTORS = [
    # Generic staff/person containers
    '.staff-member', '.staff-card', '.person', '.employee',
    '.coach', '.coaching-staff', '.staff-directory-item',
    # Common athletic department selectors
    '.roster-card', '.bio-card', '.staff-bio',
    # Grid/list items that might contain staff
    '.grid-item', '.list-item', '.directory-item',
    # Generic containers with staff-related keywords
    '[class*="staff"]', '[class*="coach"]', '[class*="person"]'
]

NAME_SELECTORS = [
    'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
    '.name', '.staff-name', '.person-name',
    '.title', '.heading', 'strong', 'b'
]

TITLE_SELECTORS = [
    '.title', '.position', '.job-title', '.role',
    '.staff-title', '.coach-title', 'em', 'i'
]

logger = logging.getLogger(__name__)

class StaffDirectoryScraper:
    def __init__(self, debug_mode=False):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })
        self.debug_mode = debug_mode
        self.debug_info = {
            "url": "",
            "selector_results": {},
            "failed_selectors": [],
            "successful_selectors": [],
            "name_extraction_results": {},
            "title_extraction_results": {},
            "fallback_used": False,
            "staff_list": []
        }

    def scrape_staff_directory(self, url: str, max_retries: int = 3) -> Tuple[Optional[List[Dict]], Optional[str], Optional[Dict]]:
        """
        Scrape staff directory and return list of staff members and content hash.
        Returns (staff_list, content_hash, debug_info) on success, (None, error_message, debug_info) on failure.
        """
        if self.debug_mode:
            self.debug_info = {
                "url": url,
                "selector_results": {},
                "failed_selectors": [],
                "successful_selectors": [],
                "name_extraction_results": {},
                "title_extraction_results": {},
                "fallback_used": False,
                "staff_list": [],
                "errors": []
            }

        for attempt in range(max_retries):
            try:
                logger.info(f"Scraping {url} (attempt {attempt + 1}/{max_retries})")

                response = self.session.get(url, timeout=30)
                response.raise_for_status()

                soup = BeautifulSoup(response.content, 'html.parser')
                staff_list = self._extract_staff_info(soup, url)

                # Create content hash for change detection
                content_hash = self._create_content_hash(staff_list)

                logger.info(f"Successfully scraped {len(staff_list)} staff members from {url}")

                if self.debug_mode:
                    self.debug_info["staff_list"] = staff_list
                    return staff_list, content_hash, self.debug_info
                return staff_list, content_hash, None

            except requests.RequestException as e:
                error_msg = f"Request failed for {url} (attempt {attempt + 1}): {str(e)}"
                logger.warning(error_msg)
                if self.debug_mode:
                    self.debug_info["errors"].append(error_msg)
                if attempt == max_retries - 1:
                    return None, f"Failed to fetch URL after {max_retries} attempts: {str(e)}", self.debug_info if self.debug_mode else None
                time.sleep(2 ** attempt)  # Exponential backoff

            except Exception as e:
                error_msg = f"Unexpected error scraping {url}: {str(e)}"
                logger.error(error_msg)
                if self.debug_mode:
                    self.debug_info["errors"].append(error_msg)
                return None, f"Scraping error: {str(e)}", self.debug_info if self.debug_mode else None

        return None, "Maximum retries exceeded", self.debug_info if self.debug_mode else None

    def _extract_staff_info(self, soup: BeautifulSoup, base_url: str) -> List[Dict]:
        """
        Extract staff information from the parsed HTML.
        This uses heuristics to identify staff members from common directory structures.
        """
        staff_list = []

        for selector in STAFF_CONTAINER_SELECTORS:
            elements = soup.select(selector)
            if elements:
                logger.debug(f"Found {len(elements)} elements with selector: {selector}")

                if self.debug_mode:
                    self.debug_info["selector_results"][selector] = len(elements)

                # Limit processing to prevent timeouts on large sites
                max_elements = 300
                if len(elements) > max_elements:
                    logger.info(f"Limiting processing to {max_elements} elements (found {len(elements)})")
                    elements = elements[:max_elements]

                for element in elements:
                    staff_info = self._parse_staff_element(element, base_url)
                    if staff_info and staff_info not in staff_list:
                        staff_list.append(staff_info)

                    # Break early if we have enough staff members
                    if len(staff_list) > 150:
                        logger.info(f"Found sufficient staff members ({len(staff_list)}), stopping extraction")
                        break

                # If we found staff with this selector, don't try other selectors
                if staff_list:
                    logger.info(f"Successfully found {len(staff_list)} staff members with selector: {selector}")
                    if self.debug_mode:
                        self.debug_info["successful_selectors"].append(selector)
                    break
                elif self.debug_mode:
                    self.debug_info["failed_selectors"].append(selector)

        # If no specific selectors work, try to find patterns in the HTML
        if not staff_list:
            if self.debug_mode:
                self.debug_info["fallback_used"] = True
            staff_list = self._fallback_extraction(soup, base_url)

        # Remove duplicates based on name
        seen_names = set()
        unique_staff = []
        for staff in staff_list:
            name_key = staff.get('name', '').strip().lower()
            if name_key and name_key not in seen_names:
                seen_names.add(name_key)
                unique_staff.append(staff)

        return unique_staff

    def _parse_staff_element(self, element, base_url: str) -> Optional[Dict]:
        """Parse a single staff member element."""
        try:
            # Extract name - try various selectors
            name = None
            for selector in NAME_SELECTORS:
                try:
                    name_elem = element.select_one(selector)
                    if name_elem and name_elem.get_text(strip=True):
                        name = name_elem.get_text(strip=True)
                        if self.debug_mode:
                            if selector not in self.debug_info["name_extraction_results"]:
                                self.debug_info["name_extraction_results"][selector] = 0
                            self.debug_info["name_extraction_results"][selector] += 1
                        break
                except Exception as e:
                    logging.debug(f"Selector '{selector}' failed: {e}")
                    continue

            # If no name in child elements, check the element itself
            if not name:
                text = element.get_text(strip=True)
                if text and len(text) < 100:  # Reasonable name length
                    name = text
                    if self.debug_mode and "element_text" not in self.debug_info["name_extraction_results"]:
                        self.debug_info["name_extraction_results"]["element_text"] = 0
                        self.debug_info["name_extraction_results"]["element_text"] += 1

            # Extract title/position
            title = None
            for selector in TITLE_SELECTORS:
                try:
                    title_elem = element.select_one(selector)
                    if title_elem and title_elem.get_text(strip=True):
                        title_text = title_elem.get_text(strip=True)
                        # Avoid using the name as title
                        if title_text != name:
                            title = title_text
                            if self.debug_mode:
                                if selector not in self.debug_info["title_extraction_results"]:
                                    self.debug_info["title_extraction_results"][selector] = 0
                                self.debug_info["title_extraction_results"][selector] += 1
                            break
                except Exception as e:
                    logging.debug(f"Title selector '{selector}' failed: {e}")
                    continue

            # Extract additional info
            email = None
            phone = None

            # Look for email links
            try:
                email_link = element.select_one('a[href^="mailto:"]')
                if email_link:
                    email = email_link.get('href').replace('mailto:', '')
            except Exception as e:
                logging.debug(f"Email extraction failed: {e}")

            # Look for phone links
            try:
                phone_link = element.select_one('a[href^="tel:"]')
                if phone_link:
                    phone = phone_link.get('href').replace('tel:', '')
            except Exception as e:
                logging.debug(f"Phone extraction failed: {e}")

            if name:
                staff_info = {
                    'name': name,
                    'title': title or '',
                    'email': email or '',
                    'phone': phone or '',
                    'element_html': str(element)[:500]  # Store snippet for comparison
                }
                return staff_info

        except Exception as e:
            logger.debug(f"Error parsing staff element: {str(e)}")

        return None

    def _fallback_extraction(self, soup: BeautifulSoup, base_url: str) -> List[Dict]:
        """
        Fallback method to extract staff info when specific selectors don't work.
        """
        staff_list = []

        # Look for patterns that might indicate staff listings
        # Find all text that looks like names followed by titles
        text_blocks = soup.find_all(['div', 'p', 'li', 'td'])

        for block in text_blocks:
            text = block.get_text(strip=True)
            if not text or len(text) > 200:
                continue

            # Look for patterns like "John Doe, Head Coach" or "Jane Smith - Assistant Coach"
            if any(keyword in text.lower() for keyword in ['coach', 'director', 'manager', 'coordinator', 'assistant']):
                lines = [line.strip() for line in text.split('\n') if line.strip()]

                for line in lines:
                    # Try to split name and title
                    if ',' in line:
                        parts = line.split(',', 1)
                        if len(parts) == 2:
                            name, title = parts[0].strip(), parts[1].strip()
                            if self._looks_like_name(name):
                                staff_list.append({
                                    'name': name,
                                    'title': title,
                                    'email': '',
                                    'phone': '',
                                    'element_html': str(block)[:500]
                                })
                    elif ' - ' in line:
                        parts = line.split(' - ', 1)
                        if len(parts) == 2:
                            name, title = parts[0].strip(), parts[1].strip()
                            if self._looks_like_name(name):
                                staff_list.append({
                                    'name': name,
                                    'title': title,
                                    'email': '',
                                    'phone': '',
                                    'element_html': str(block)[:500]
                                })

        return staff_list

    def _looks_like_name(self, text: str) -> bool:
        """Simple heuristic to check if text looks like a person's name."""
        if not text or len(text) < 2 or len(text) > 50:
            return False

        words = text.split()
        if len(words) < 2:
            return False

        # Should contain mostly letters and common name characters
        if not all(c.isalpha() or c.isspace() or c in "'-." for c in text):
            return False

        return True

    def _create_content_hash(self, staff_list: List[Dict]) -> str:
        """Create a hash of the staff list for change detection."""
        # Create a normalized string representation
        content_str = ""
        for staff in sorted(staff_list, key=lambda x: x.get('name', '')):
            content_str += f"{staff.get('name', '')}{staff.get('title', '')}"

        return hashlib.sha256(content_str.encode('utf-8')).hexdigest()

    def compare_staff_lists(self, old_list: List[Dict], new_list: List[Dict]) -> List[Dict]:
        """
        Compare two staff lists and return detected changes.
        Returns list of change dictionaries.
        """
        changes = []

        # Create lookup dictionaries
        old_staff = {staff['name']: staff for staff in old_list}
        new_staff = {staff['name']: staff for staff in new_list}

        # Find additions
        for name, staff in new_staff.items():
            if name not in old_staff:
                changes.append({
                    'change_type': 'added',
                    'staff_name': name,
                    'staff_title': staff.get('title', ''),
                    'change_description': f"New staff member added: {name} - {staff.get('title', 'No title')}"
                })

        # Find removals
        for name, staff in old_staff.items():
            if name not in new_staff:
                changes.append({
                    'change_type': 'removed',
                    'staff_name': name,
                    'staff_title': staff.get('title', ''),
                    'change_description': f"Staff member removed: {name} - {staff.get('title', 'No title')}"
                })

        # Find modifications (title changes)
        for name in old_staff.keys() & new_staff.keys():
            old_title = old_staff[name].get('title', '')
            new_title = new_staff[name].get('title', '')

            if old_title != new_title:
                changes.append({
                    'change_type': 'modified',
                    'staff_name': name,
                    'staff_title': new_title,
                    'change_description': f"Title changed for {name}: '{old_title}' → '{new_title}'"
                })

        return changes
