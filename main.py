from app import app
import routes  # noqa: F401

# Initialize scheduler after app starts, not during import
scheduler_initialized = False

def init_scheduler():
    """Initialize scheduler after app is ready"""
    global scheduler_initialized
    if not scheduler_initialized:
        try:
            from scheduler_service import start_scheduler
            start_scheduler()
            scheduler_initialized = True
        except Exception as e:
            print(f"Scheduler initialization warning: {e}")

# Initialize scheduler on first request using modern Flask pattern
@app.before_request
def ensure_scheduler():
    init_scheduler()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
