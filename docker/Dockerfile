# ╔══════════════════════════════════════════════════════════════╗
# ║  Multi-Stage Production Dockerfile                         ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ║  Optimized for: Security, Size, Layer Caching             ║
# ╚══════════════════════════════════════════════════════════════╝

# ─── Stage 1: Builder ──────────────────────────────────────────
FROM python:3.11-slim AS builder

WORKDIR /build

# Install dependencies first (layer caching optimization)
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ─── Stage 2: Production ──────────────────────────────────────
FROM python:3.11-slim AS production

# Security: Add metadata labels
LABEL maintainer="Saurabh Singh Rajput <github.com/DevSars24>"
LABEL description="Production Flask App for AWS EKS"
LABEL version="2.0.0"

# Security: Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser -d /app -s /sbin/nologin appuser

WORKDIR /app

# Copy installed dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application code
COPY app/ ./app/
COPY run.py .

# Security: Set ownership and switch to non-root user
RUN chown -R appuser:appuser /app
USER appuser

# Expose application port
EXPOSE 5000

# Health check instruction for Docker
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Environment variables
ENV FLASK_ENV=production \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Production server with Gunicorn
CMD ["gunicorn", \
     "--bind", "0.0.0.0:5000", \
     "--workers", "4", \
     "--threads", "2", \
     "--timeout", "120", \
     "--access-logfile", "-", \
     "--error-logfile", "-", \
     "--log-level", "info", \
     "run:application"]
