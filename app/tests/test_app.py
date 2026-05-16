"""
Unit Tests for Flask Application
==================================
Comprehensive test suite covering all endpoints,
health checks, error handling, and configuration.

Author: Saurabh Singh Rajput (@DevSars24)
"""

import pytest
from app.main import create_app


@pytest.fixture
def app():
    """Create application instance for testing."""
    app = create_app("testing")
    yield app


@pytest.fixture
def client(app):
    """Create test client."""
    return app.test_client()


# ═══════════════════════════════════════════════════════════════════════════
# ROOT ENDPOINT TESTS
# ═══════════════════════════════════════════════════════════════════════════

class TestRootEndpoint:
    """Tests for the root (/) endpoint."""

    def test_root_returns_200(self, client):
        """Root endpoint should return HTTP 200."""
        response = client.get("/")
        assert response.status_code == 200

    def test_root_returns_json(self, client):
        """Root endpoint should return JSON content."""
        response = client.get("/")
        assert response.content_type == "application/json"

    def test_root_contains_message(self, client):
        """Root endpoint should contain welcome message."""
        response = client.get("/")
        data = response.get_json()
        assert "message" in data
        assert "Flask App running on AWS EKS" in data["message"]

    def test_root_contains_author(self, client):
        """Root endpoint should credit the author."""
        response = client.get("/")
        data = response.get_json()
        assert data["author"] == "Saurabh Singh Rajput"

    def test_root_contains_version(self, client):
        """Root endpoint should contain app version."""
        response = client.get("/")
        data = response.get_json()
        assert "version" in data


# ═══════════════════════════════════════════════════════════════════════════
# APP INFO ENDPOINT TESTS
# ═══════════════════════════════════════════════════════════════════════════

class TestAppInfoEndpoint:
    """Tests for the /api/info endpoint."""

    def test_info_returns_200(self, client):
        """Info endpoint should return HTTP 200."""
        response = client.get("/api/info")
        assert response.status_code == 200

    def test_info_contains_app_name(self, client):
        """Info endpoint should contain app name."""
        data = client.get("/api/info").get_json()
        assert "app_name" in data

    def test_info_contains_endpoints_list(self, client):
        """Info endpoint should list all available endpoints."""
        data = client.get("/api/info").get_json()
        assert "endpoints" in data
        assert len(data["endpoints"]) >= 4

    def test_info_contains_uptime(self, client):
        """Info endpoint should report uptime."""
        data = client.get("/api/info").get_json()
        assert "uptime_seconds" in data
        assert data["uptime_seconds"] >= 0


# ═══════════════════════════════════════════════════════════════════════════
# HEALTH CHECK TESTS (Kubernetes Probes)
# ═══════════════════════════════════════════════════════════════════════════

class TestHealthEndpoints:
    """Tests for Kubernetes liveness and readiness probes."""

    def test_liveness_returns_200(self, client):
        """Liveness probe should return HTTP 200."""
        response = client.get("/health")
        assert response.status_code == 200

    def test_liveness_status_healthy(self, client):
        """Liveness probe should report healthy status."""
        data = client.get("/health").get_json()
        assert data["status"] == "healthy"

    def test_liveness_contains_timestamp(self, client):
        """Liveness probe should include timestamp."""
        data = client.get("/health").get_json()
        assert "timestamp" in data

    def test_readiness_returns_200(self, client):
        """Readiness probe should return HTTP 200 when ready."""
        response = client.get("/ready")
        assert response.status_code == 200

    def test_readiness_status_ready(self, client):
        """Readiness probe should report ready status."""
        data = client.get("/ready").get_json()
        assert data["status"] == "ready"

    def test_readiness_includes_checks(self, client):
        """Readiness probe should include health checks."""
        data = client.get("/ready").get_json()
        assert "checks" in data
        assert data["checks"]["app"] is True


# ═══════════════════════════════════════════════════════════════════════════
# METRICS ENDPOINT TESTS
# ═══════════════════════════════════════════════════════════════════════════

class TestMetricsEndpoint:
    """Tests for the /metrics endpoint."""

    def test_metrics_returns_200(self, client):
        """Metrics endpoint should return HTTP 200."""
        response = client.get("/metrics")
        assert response.status_code == 200

    def test_metrics_contains_request_count(self, client):
        """Metrics should track total requests."""
        data = client.get("/metrics").get_json()
        assert "total_requests" in data

    def test_metrics_contains_uptime(self, client):
        """Metrics should report uptime."""
        data = client.get("/metrics").get_json()
        assert "uptime_seconds" in data


# ═══════════════════════════════════════════════════════════════════════════
# ERROR HANDLING TESTS
# ═══════════════════════════════════════════════════════════════════════════

class TestErrorHandling:
    """Tests for error handler responses."""

    def test_404_returns_json(self, client):
        """404 errors should return JSON response."""
        response = client.get("/nonexistent-endpoint")
        assert response.status_code == 404
        data = response.get_json()
        assert data["error"] == "Resource not found"

    def test_405_returns_json(self, client):
        """405 errors should return JSON response."""
        response = client.post("/health")
        assert response.status_code == 405


# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION TESTS
# ═══════════════════════════════════════════════════════════════════════════

class TestConfiguration:
    """Tests for application configuration."""

    def test_testing_config(self):
        """Testing config should enable DEBUG and TESTING."""
        app = create_app("testing")
        assert app.config["DEBUG"] is True
        assert app.config["TESTING"] is True

    def test_development_config(self):
        """Development config should enable DEBUG."""
        app = create_app("development")
        assert app.config["DEBUG"] is True
        assert app.config["TESTING"] is False

    def test_production_config(self):
        """Production config should disable DEBUG."""
        app = create_app("production")
        assert app.config["DEBUG"] is False
        assert app.config["TESTING"] is False
