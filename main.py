from app import app
import routes  # noqa: F401

# Deployment checkpoint - force fresh deployment
# Production URL: https://workspace-mattbrownep.replit.app

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
