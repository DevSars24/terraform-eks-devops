"""
Application Factory
====================
Creates and configures the Flask application using the factory pattern.
This enables multiple instances and easier testing.

Author: Saurabh Singh Rajput (@DevSars24)
"""

import logging
import os
from flask import Flask
from app.config import config_by_name


def create_app(config_name: str = None) -> Flask:
    """
    Application factory function.

    Args:
        config_name: Configuration environment name (development/staging/production).
                     Defaults to FLASK_ENV environment variable or 'development'.

    Returns:
        Configured Flask application instance.
    """
    if config_name is None:
        config_name = os.getenv("FLASK_ENV", "development")

    app = Flask(__name__)
    app.config.from_object(config_by_name[config_name])

    if config_name == "production":
        secret_key = os.getenv("SECRET_KEY")
        if not secret_key:
            raise ValueError("SECRET_KEY environment variable must be set in production")
        app.config["SECRET_KEY"] = secret_key

    # ─── Configure Structured Logging ───────────────────────────────────
    _configure_logging(app)

    # ─── Register Blueprints ────────────────────────────────────────────
    from app.routes import api_bp, health_bp

    app.register_blueprint(api_bp)
    app.register_blueprint(health_bp)

    # ─── Register Prometheus Metrics ────────────────────────────────────
    from prometheus_flask_exporter import PrometheusMetrics

    PrometheusMetrics(app)

    # ─── Register Error Handlers ────────────────────────────────────────
    _register_error_handlers(app)

    # ─── Enable CORS ────────────────────────────────────────────────────
    from flask_cors import CORS

    CORS(app, resources={r"/*": {"origins": "*"}})

    # ─── Security Guardrail Headers (OWASP Hardening) ───────────────────
    @app.after_request
    def _add_security_headers(response):
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
        response.headers["Content-Security-Policy"] = "default-src 'self'; frame-ancestors 'none';"
        if not app.config.get("DEBUG", False):
            response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
        return response

    app.logger.info(
        "Application initialized | env=%s | debug=%s",
        config_name,
        app.config.get("DEBUG", False),
    )

    return app


def _configure_logging(app: Flask) -> None:
    """Configure structured logging with proper formatting."""
    log_level = os.getenv("LOG_LEVEL", "INFO").upper()

    handler = logging.StreamHandler()
    handler.setLevel(getattr(logging, log_level, logging.INFO))

    formatter = logging.Formatter(
        fmt="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    handler.setFormatter(formatter)

    app.logger.handlers.clear()
    app.logger.addHandler(handler)
    app.logger.setLevel(getattr(logging, log_level, logging.INFO))

    # Suppress noisy werkzeug logs in production
    if not app.config.get("DEBUG"):
        logging.getLogger("werkzeug").setLevel(logging.WARNING)


def _register_error_handlers(app: Flask) -> None:
    """Register global error handlers for consistent API responses."""

    @app.errorhandler(404)
    def not_found(error):
        return {"error": "Resource not found", "status": 404}, 404

    @app.errorhandler(500)
    def internal_error(error):
        app.logger.error("Internal server error: %s", str(error))
        return {"error": "Internal server error", "status": 500}, 500

    @app.errorhandler(405)
    def method_not_allowed(error):
        return {"error": "Method not allowed", "status": 405}, 405
