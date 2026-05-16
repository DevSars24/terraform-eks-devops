"""
Flask Application Package
========================
Production-grade Flask application with health checks,
structured logging, and Prometheus metrics integration.

Author: Saurabh Singh Rajput (@DevSars24)
"""

from app.main import create_app

__all__ = ["create_app"]
