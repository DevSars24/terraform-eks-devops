"""
Application Configuration
==========================
Environment-based configuration classes following 12-factor app methodology.

Author: Saurabh Singh Rajput (@DevSars24)
"""

import os


class BaseConfig:
    """Base configuration shared across all environments."""
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key-change-in-production")
    APP_NAME = "Flask EKS DevOps App"
    APP_VERSION = "2.0.0"
    JSON_SORT_KEYS = False


class DevelopmentConfig(BaseConfig):
    """Development environment configuration."""
    DEBUG = True
    TESTING = False
    LOG_LEVEL = "DEBUG"


class StagingConfig(BaseConfig):
    """Staging environment configuration."""
    DEBUG = False
    TESTING = False
    LOG_LEVEL = "INFO"


class ProductionConfig(BaseConfig):
    """Production environment configuration."""
    DEBUG = False
    TESTING = False
    LOG_LEVEL = "WARNING"
    SECRET_KEY = os.getenv("SECRET_KEY")  # Must be set in production


class TestingConfig(BaseConfig):
    """Testing environment configuration."""
    DEBUG = True
    TESTING = True
    LOG_LEVEL = "DEBUG"


# ─── Configuration Map ─────────────────────────────────────────────────────
config_by_name = {
    "development": DevelopmentConfig,
    "staging": StagingConfig,
    "production": ProductionConfig,
    "testing": TestingConfig,
}
