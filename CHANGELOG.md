# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-05-16

### Added
- 🏗️ **Modular Terraform** — VPC, EKS, and ECR as separate reusable modules
- 🐳 **Multi-stage Docker** — Production-hardened Dockerfile with non-root user
- ☸️ **Kubernetes Manifests** — Complete Kustomize setup (base + dev/staging/prod overlays)
- ⎈ **Helm Chart** — Full Helm chart with per-environment values
- 🔄 **CI/CD Pipelines** — GitHub Actions (CI + CD + Terraform) and Jenkins
- 📊 **Monitoring** — Prometheus, Grafana, and AlertManager configurations
- 🔒 **Security** — Trivy scanning, RBAC, Network Policies, Pod Security Standards
- 🧪 **Testing** — Comprehensive pytest suite with coverage
- 📦 **Docker Compose** — Local development stack (app + redis + prometheus + grafana)
- 🛠️ **Makefile** — Developer shortcuts for all common operations
- 📖 **Documentation** — Architecture, deployment guide, and troubleshooting docs
- 🏷️ **Multi-environment** — Separate dev/staging/prod configurations

### Changed
- Upgraded Flask app to production-grade with app factory pattern
- Added health check endpoints (`/health`, `/ready`, `/metrics`)
- Restructured project for industry-standard DevOps practices

### Removed
- Removed terraform state files from version control
- Removed basic single-file app.py (replaced with modular structure)

## [1.0.0] - 2025-05-16

### Added
- Initial Flask application
- Basic Dockerfile
- Terraform configuration for VPC and EKS

---

**Author:** Saurabh Singh Rajput ([@DevSars24](https://github.com/DevSars24))
