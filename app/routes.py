"""
API Routes & Health Check Endpoints
=====================================
Production-grade route definitions with health checks,
readiness probes, and application metrics endpoints.

Author: Saurabh Singh Rajput (@DevSars24)
"""

import time
import platform
from datetime import datetime, timezone
from flask import Blueprint, jsonify, request, current_app

# ─── Blueprints ─────────────────────────────────────────────────────────────
api_bp = Blueprint("api", __name__)
health_bp = Blueprint("health", __name__)

# ─── Application Start Time (for uptime calculation) ───────────────────────
_start_time = time.time()

# ─── Simple In-Memory Metrics ──────────────────────────────────────────────
_metrics = {
    "total_requests": 0,
    "total_errors": 0,
    "endpoint_hits": {},
}


# ═══════════════════════════════════════════════════════════════════════════
# API ROUTES
# ═══════════════════════════════════════════════════════════════════════════

@api_bp.before_request
def _track_request():
    """Track request metrics before processing."""
    _metrics["total_requests"] += 1
    endpoint = request.endpoint or "unknown"
    _metrics["endpoint_hits"][endpoint] = _metrics["endpoint_hits"].get(endpoint, 0) + 1


@api_bp.route("/")
def home():
    """
    Root endpoint — Application landing page.

    Returns:
        JSON response with welcome message and app info.
    """
    return jsonify({
        "message": "🚀 Flask App running on AWS EKS",
        "version": current_app.config.get("APP_VERSION", "unknown"),
        "environment": current_app.config.get("ENV", "production"),
        "author": "Saurabh Singh Rajput",
        "github": "https://github.com/DevSars24",
        "docs": "/api/info",
    })


@api_bp.route("/api/info")
def app_info():
    """
    Application information endpoint.

    Returns:
        JSON response with detailed application metadata.
    """
    return jsonify({
        "app_name": current_app.config.get("APP_NAME"),
        "version": current_app.config.get("APP_VERSION"),
        "python_version": platform.python_version(),
        "platform": platform.platform(),
        "uptime_seconds": round(time.time() - _start_time, 2),
        "endpoints": [
            {"path": "/", "method": "GET", "description": "Welcome page"},
            {"path": "/api/info", "method": "GET", "description": "App information"},
            {"path": "/health", "method": "GET", "description": "Liveness probe"},
            {"path": "/ready", "method": "GET", "description": "Readiness probe"},
            {"path": "/metrics", "method": "GET", "description": "App metrics"},
        ],
    })


# ═══════════════════════════════════════════════════════════════════════════
# HEALTH CHECK ENDPOINTS (Kubernetes Probes)
# ═══════════════════════════════════════════════════════════════════════════

@health_bp.route("/health")
def liveness():
    """
    Liveness Probe — Kubernetes uses this to know if the app is alive.
    If this fails, Kubernetes will restart the container.

    Returns:
        200 OK if the application process is running.
    """
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "uptime_seconds": round(time.time() - _start_time, 2),
    }), 200


@health_bp.route("/ready")
def readiness():
    """
    Readiness Probe — Kubernetes uses this to know if the app is ready
    to accept traffic. If this fails, the pod is removed from the
    Service's endpoints (no traffic routed to it).

    Returns:
        200 OK if the application is ready to serve requests.
    """
    # In production, you'd check database connections, cache, etc.
    checks = {
        "app": True,
        "config_loaded": current_app.config.get("APP_NAME") is not None,
    }

    all_healthy = all(checks.values())
    status_code = 200 if all_healthy else 503

    return jsonify({
        "status": "ready" if all_healthy else "not_ready",
        "checks": checks,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }), status_code


@health_bp.route("/metrics")
def metrics():
    """
    Application Metrics Endpoint — Exposes basic application metrics.
    In production, integrate with Prometheus client library.

    Returns:
        JSON response with application metrics.
    """
    return jsonify({
        "uptime_seconds": round(time.time() - _start_time, 2),
        "total_requests": _metrics["total_requests"],
        "total_errors": _metrics["total_errors"],
        "endpoint_hits": _metrics["endpoint_hits"],
        "python_version": platform.python_version(),
        "timestamp": datetime.now(timezone.utc).isoformat(),
    })
