"""
Application Entrypoint
=======================
Production WSGI entrypoint for the Flask application.
Uses Gunicorn in production, Flask dev server in development.

Author: Saurabh Singh Rajput (@DevSars24)
"""

from app.main import create_app

application = create_app()

if __name__ == "__main__":
    application.run(host="0.0.0.0", port=5000)
