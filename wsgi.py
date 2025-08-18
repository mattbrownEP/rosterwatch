#!/usr/bin/env python3
"""
WSGI entry point for production deployment.
This ensures all modules are properly imported for Gunicorn.
"""

import os
import sys

# Add current directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Import the Flask application
from main import app

# Make sure routes are imported
import routes  # noqa: F401

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)