"""State-specific Open Records Request information and templates."""

STATE_INFO = {
    'AL': {
        'name': 'Alabama',
        'law_name': 'Alabama Open Records Act',
        'response_days': 7,
        'fee_structure': 'Reasonable copying costs',
        'contact_title': 'Records Custodian',
        'template_key': 'alabama'
    },
    'AZ': {
        'name': 'Arizona',
        'law_name': 'Arizona Public Records Law',
        'response_days': 5,
        'fee_structure': 'Actual costs of copying',
        'contact_title': 'Public Records Officer',
        'template_key': 'arizona'
    },
    'AR': {
        'name': 'Arkansas',
        'law_name': 'Arkansas Freedom of Information Act',
        'response_days': 3,
        'fee_structure': 'Reasonable copying costs',
        'contact_title': 'FOI Officer',
        'template_key': 'arkansas'
    },
    'CA': {
        'name': 'California',
        'law_name': 'California Public Records Act',
        'response_days': 10,
        'fee_structure': 'Direct costs of duplication',
        'contact_title': 'Public Records Coordinator',
        'template_key': 'california'
    },
    'FL': {
        'name': 'Florida',
        'law_name': 'Florida Sunshine Law',
        'response_days': 5,
        'fee_structure': 'Actual cost of duplication',
        'contact_title': 'Records Custodian',
        'template_key': 'florida'
    },
    'GA': {
        'name': 'Georgia',
        'law_name': 'Georgia Open Records Act',
        'response_days': 3,
        'fee_structure': 'Reasonable copying costs',
        'contact_title': 'Open Records Officer',
        'template_key': 'georgia'
    },
    'IN': {
        'name': 'Indiana',
        'law_name': 'Indiana Access to Public Records Act',
        'response_days': 7,
        'fee_structure': 'Copying and processing costs',
        'contact_title': 'Records Custodian',
        'template_key': 'indiana'
    },
    'LA': {
        'name': 'Louisiana',
        'law_name': 'Louisiana Public Records Act',
        'response_days': 3,
        'fee_structure': 'Actual copying costs',
        'contact_title': 'Custodian of Records',
        'template_key': 'louisiana'
    },
    'MI': {
        'name': 'Michigan',
        'law_name': 'Michigan Freedom of Information Act',
        'response_days': 5,
        'fee_structure': 'Reasonable fees',
        'contact_title': 'FOIA Coordinator',
        'template_key': 'michigan'
    },
    'MS': {
        'name': 'Mississippi',
        'law_name': 'Mississippi Public Records Act',
        'response_days': 7,
        'fee_structure': 'Reasonable copying costs',
        'contact_title': 'Records Custodian',
        'template_key': 'mississippi'
    },
    'NC': {
        'name': 'North Carolina',
        'law_name': 'North Carolina Public Records Law',
        'response_days': 5,
        'fee_structure': 'Actual costs',
        'contact_title': 'Records Officer',
        'template_key': 'north_carolina'
    },
    'OH': {
        'name': 'Ohio',
        'law_name': 'Ohio Public Records Act',
        'response_days': 'Reasonable time',
        'fee_structure': 'Actual cost of copies',
        'contact_title': 'Records Custodian',
        'template_key': 'ohio'
    },
    'PA': {
        'name': 'Pennsylvania',
        'law_name': 'Pennsylvania Right-to-Know Law',
        'response_days': 5,
        'fee_structure': 'Reasonable fees',
        'contact_title': 'Right-to-Know Officer',
        'template_key': 'pennsylvania'
    },
    'TN': {
        'name': 'Tennessee',
        'law_name': 'Tennessee Public Records Act',
        'response_days': 7,
        'fee_structure': 'Reasonable copying costs',
        'contact_title': 'Records Custodian',
        'template_key': 'tennessee'
    },
    'TX': {
        'name': 'Texas',
        'law_name': 'Texas Public Information Act',
        'response_days': 10,
        'fee_structure': 'Actual costs',
        'contact_title': 'Public Information Officer',
        'template_key': 'texas'
    },
    'VA': {
        'name': 'Virginia',
        'law_name': 'Virginia Freedom of Information Act',
        'response_days': 5,
        'fee_structure': 'Reasonable charges',
        'contact_title': 'FOIA Officer',
        'template_key': 'virginia'
    },
    'WV': {
        'name': 'West Virginia',
        'law_name': 'West Virginia Freedom of Information Act',
        'response_days': 5,
        'fee_structure': 'Reasonable costs',
        'contact_title': 'Freedom of Information Officer',
        'template_key': 'west_virginia'
    }
}

POSITION_CLASSIFICATION = {
    'high': [
        'head coach', 'assistant coach', 'associate head coach', 'coordinator',
        'athletic director', 'associate athletic director', 'assistant athletic director',
        'director of', 'deputy athletic director'
    ],
    'medium': [
        'manager', 'analyst', 'specialist', 'supervisor', 'administrator',
        'trainer', 'strength', 'conditioning', 'recruiting'
    ],
    'standard': [
        'assistant', 'associate', 'staff', 'intern', 'student', 'volunteer'
    ]
}

def classify_position_importance(title):
    """Classify the importance of a position based on title."""
    if not title:
        return 'standard'
    
    title_lower = title.lower()
    
    for importance, keywords in POSITION_CLASSIFICATION.items():
        for keyword in keywords:
            if keyword in title_lower:
                return importance
    
    return 'standard'

def estimate_contract_likelihood(title, change_type):
    """Estimate likelihood of having a publicly accessible contract."""
    if not title or change_type == 'removed':
        return 'none'
    
    importance = classify_position_importance(title)
    title_lower = title.lower()
    
    # High-value positions likely to have contracts
    if importance == 'high':
        if any(word in title_lower for word in ['head coach', 'coordinator', 'director']):
            return 'high'
        return 'medium'
    
    # Medium importance positions
    if importance == 'medium':
        return 'medium'
    
    # Standard positions unlikely to have significant contracts
    return 'low'

REQUEST_TEMPLATES = {
    'general': """
Subject: Public Records Request - Athletic Department Contract Information

Dear {contact_title},

I am writing to request access to public records under the {state_law}. I am seeking the following documents related to a recent staff change in your athletic department:

REQUESTED RECORDS:
- Employment contract, letter of appointment, or similar employment documentation for {staff_name}, {staff_title}
- Any amendments, modifications, or addenda to the above contract
- Salary information and compensation details
- Start date and contract term information

BACKGROUND:
This request relates to the recent {change_type} of {staff_name} as {staff_title}, which was detected on {date}.

I understand that under {state_law}, you have {response_days} days to respond to this request. If any portion of these records is exempt from disclosure, please provide the non-exempt portions and cite the specific exemption for any withheld information.

If there are any copying fees associated with this request, please contact me if they exceed $25.

Thank you for your assistance. I look forward to your response within the statutory timeframe.

Sincerely,
[Your Name]
[Your Title/Organization]
[Contact Information]
""",
    
    'coaching': """
Subject: Public Records Request - Coaching Contract Information

Dear {contact_title},

Pursuant to the {state_law}, I respectfully request access to the following public records regarding a recent coaching change in your athletic department:

REQUESTED DOCUMENTS:
- Complete employment contract for {staff_name}, {staff_title}
- All amendments, extensions, or modifications to the contract
- Compensation structure including base salary, bonuses, and incentives
- Performance metrics and evaluation criteria
- Buyout clauses and termination provisions
- Start date and contract duration

CONTEXT:
This request concerns the recent {change_type} of {staff_name} as {staff_title}, identified on {date}. Given the public interest in coaching compensation at state institutions, I believe these records should be readily accessible.

Please provide these records within {response_days} days as required by law. If any documents contain confidential information, please redact only the exempt portions and provide the remainder.

I am prepared to pay reasonable copying costs up to $50. Please contact me if fees will exceed this amount.

Thank you for your prompt attention to this matter.

Best regards,
[Your Name]
[Your Organization]
[Contact Information]
"""
}