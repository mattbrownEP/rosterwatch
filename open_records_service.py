"""Service for handling Open Records Request functionality."""

import logging
from datetime import datetime, timedelta
from typing import Dict, List, Optional
from state_info import STATE_INFO, classify_position_importance, estimate_contract_likelihood, REQUEST_TEMPLATES

logger = logging.getLogger(__name__)

class OpenRecordsService:
    def __init__(self):
        self.state_info = STATE_INFO
        self.templates = REQUEST_TEMPLATES
    
    def get_state_info(self, state_code: str) -> Optional[Dict]:
        """Get state-specific Open Records information."""
        if not state_code:
            return None
        return self.state_info.get(state_code.upper())
    
    def classify_staff_change(self, staff_name: str, staff_title: str, change_type: str) -> Dict:
        """Classify a staff change for Open Records priority."""
        importance = classify_position_importance(staff_title)
        contract_likelihood = estimate_contract_likelihood(staff_title, change_type)
        
        # Determine priority level
        priority = 'standard'
        if importance == 'high' and contract_likelihood in ['high', 'medium']:
            priority = 'high'
        elif importance == 'medium' or contract_likelihood == 'medium':
            priority = 'medium'
        
        return {
            'position_importance': importance,
            'contract_likelihood': contract_likelihood,
            'priority': priority,
            'recommended_action': self._get_recommended_action(importance, contract_likelihood, change_type)
        }
    
    def _get_recommended_action(self, importance: str, contract_likelihood: str, change_type: str) -> str:
        """Get recommended action for a staff change."""
        if change_type == 'removed':
            if importance == 'high':
                return 'Consider requesting separation agreement and final compensation'
            return 'Low priority - departure'
        
        if importance == 'high' and contract_likelihood == 'high':
            return 'High Priority - File Open Records Request immediately'
        elif importance == 'high' or contract_likelihood in ['high', 'medium']:
            return 'Medium Priority - File Open Records Request within 1-2 days'
        elif contract_likelihood == 'medium':
            return 'Standard Priority - Consider filing request if part of broader research'
        else:
            return 'Low Priority - Unlikely to have significant contract information'
    
    def generate_request_letter(self, staff_change: Dict, institution: Dict, custom_info: Dict = None) -> str:
        """Generate an Open Records Request letter."""
        state_info = self.get_state_info(institution.get('state', ''))
        if not state_info:
            logger.warning(f"No state info found for state: {institution.get('state')}")
            state_info = {
                'law_name': 'state open records law',
                'response_days': 'the statutory timeframe',
                'contact_title': 'Records Custodian'
            }
        
        # Determine template based on position
        template_type = 'coaching' if staff_change.get('position_importance') == 'high' else 'general'
        template = self.templates.get(template_type, self.templates['general'])
        
        # Format the template
        formatted_request = template.format(
            contact_title=institution.get('open_records_contact', state_info['contact_title']),
            state_law=state_info['law_name'],
            staff_name=staff_change.get('staff_name', 'Unknown'),
            staff_title=staff_change.get('staff_title', 'Unknown Position'),
            change_type=staff_change.get('change_type', 'change'),
            date=staff_change.get('detected_at', datetime.now()).strftime('%B %d, %Y'),
            response_days=state_info['response_days']
        )
        
        return formatted_request
    
    def get_filing_deadline(self, detected_date: datetime, urgency: str = 'standard') -> datetime:
        """Calculate recommended filing deadline based on urgency."""
        if urgency == 'high':
            return detected_date + timedelta(days=1)
        elif urgency == 'medium':
            return detected_date + timedelta(days=3)
        else:
            return detected_date + timedelta(days=7)
    
    def get_response_deadline(self, filed_date: datetime, state_code: str) -> datetime:
        """Calculate expected response deadline based on state law."""
        state_info = self.get_state_info(state_code)
        if not state_info:
            return filed_date + timedelta(days=10)  # Default
        
        response_days = state_info.get('response_days', 10)
        if isinstance(response_days, str):
            response_days = 10  # Default for "reasonable time"
        
        return filed_date + timedelta(days=response_days)
    
    def get_institution_state_from_url(self, url: str) -> Optional[str]:
        """Attempt to determine institution state from URL."""
        # Common state indicators in athletic URLs
        state_mappings = {
            'alabama': 'AL', 'auburn': 'AL', 'uab': 'AL', 'troy': 'AL', 'southalabama': 'AL',
            'arizona': 'AZ', 'asu': 'AZ', 'arizonastate': 'AZ', 'nau': 'AZ',
            'arkansas': 'AR', 'arkansasstate': 'AR', 'ualr': 'AR',
            'california': 'CA', 'stanford': 'CA', 'usc': 'CA', 'ucla': 'CA', 'berkeley': 'CA',
            'florida': 'FL', 'fsu': 'FL', 'miami': 'FL', 'ucf': 'FL', 'usf': 'FL',
            'georgia': 'GA', 'georgiatech': 'GA', 'georgiastate': 'GA', 'georgiasouthern': 'GA',
            'indiana': 'IN', 'purdue': 'IN', 'ballstate': 'IN', 'butler': 'IN',
            'louisiana': 'LA', 'lsu': 'LA', 'tulane': 'LA', 'ull': 'LA',
            'michigan': 'MI', 'michiganstate': 'MI', 'westernmichigan': 'MI',
            'mississippi': 'MS', 'olemiss': 'MS', 'mississippistate': 'MS', 'southernmiss': 'MS',
            'northcarolina': 'NC', 'duke': 'NC', 'ncstate': 'NC', 'wakeforest': 'NC',
            'ohio': 'OH', 'ohiostate': 'OH', 'cincinnati': 'OH', 'toledo': 'OH',
            'pennsylvania': 'PA', 'pennstate': 'PA', 'pitt': 'PA', 'temple': 'PA',
            'tennessee': 'TN', 'vanderbilt': 'TN', 'memphis': 'TN', 'mtsu': 'TN',
            'texas': 'TX', 'ut': 'TX', 'tamu': 'TX', 'texastech': 'TX', 'baylor': 'TX',
            'virginia': 'VA', 'vt': 'VA', 'vcu': 'VA', 'jmu': 'VA',
            'westvirginia': 'WV', 'marshall': 'WV'
        }
        
        url_lower = url.lower()
        for keyword, state in state_mappings.items():
            if keyword in url_lower:
                return state
        
        return None
    
    def get_dashboard_summary(self, changes: List[Dict]) -> Dict:
        """Generate summary statistics for the dashboard."""
        total_changes = len(changes)
        high_priority = sum(1 for c in changes if c.get('position_importance') == 'high')
        requests_filed = sum(1 for c in changes if c.get('open_records_filed', False))
        pending_requests = sum(1 for c in changes if c.get('open_records_status') == 'pending')
        
        return {
            'total_changes': total_changes,
            'high_priority_changes': high_priority,
            'requests_filed': requests_filed,
            'pending_requests': pending_requests,
            'filing_rate': (requests_filed / total_changes * 100) if total_changes > 0 else 0
        }