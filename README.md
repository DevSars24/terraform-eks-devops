<div align="center">

# 🚀 Flask EKS DevOps — Production-Grade CI/CD on AWS

### *The Ultimate DevOps Engineering Reference Repository*

[![CI Pipeline](https://github.com/DevSars24/terraform-eks-devops/actions/workflows/ci.yml/badge.svg)](https://github.com/DevSars24/terraform-eks-devops/actions/workflows/ci.yml)
[![CD Pipeline](https://github.com/DevSars24/terraform-eks-devops/actions/workflows/cd.yml/badge.svg)](https://github.com/DevSars24/terraform-eks-devops/actions/workflows/cd.yml)
[![Terraform](https://github.com/DevSars24/terraform-eks-devops/actions/workflows/terraform.yml/badge.svg)](https://github.com/DevSars24/terraform-eks-devops/actions/workflows/terraform.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python&logoColor=white)](https://python.org)
[![Docker](https://img.shields.io/badge/Docker-Multi--Stage-2496ED?logo=docker&logoColor=white)](https://docker.com)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes&logoColor=white)](https://aws.amazon.com/eks/)
[![Terraform](https://img.shields.io/badge/Terraform-Modular-844FBA?logo=terraform&logoColor=white)](https://terraform.io)
[![Helm](https://img.shields.io/badge/Helm-Chart-0F1689?logo=helm&logoColor=white)](https://helm.sh)

---

**Built & Maintained by [Saurabh Singh Rajput](https://github.com/DevSars24)**

[![GitHub](https://img.shields.io/badge/GitHub-DevSars24-181717?logo=github&logoColor=white)](https://github.com/DevSars24)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Saurabh_Singh_Rajput-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/saurabh-singh-rajput-25639a306/)
[![Twitter](https://img.shields.io/badge/X_(Twitter)-@SaurabhSin15850-000000?logo=x&logoColor=white)](https://x.com/SaurabhSin15850)

</div>

---

## 📋 Table of Contents

- [About This Project](#-about-this-project)
- [DevOps Concepts Covered](#-devops-concepts-covered)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Detailed Guide](#-detailed-guide)
  - [Flask Application](#1--flask-application)
  - [Docker (Containerization)](#2--docker-containerization)
  - [Terraform (Infrastructure as Code)](#3--terraform-infrastructure-as-code)
  - [Kubernetes (Orchestration)](#4--kubernetes-orchestration)
  - [Helm (Package Management)](#5--helm-package-management)
  - [CI/CD Pipelines](#6--cicd-pipelines)
  - [Monitoring & Observability](#7--monitoring--observability)
  - [Security](#8--security)
- [Deployment Strategies](#-deployment-strategies)
- [Make Targets](#-make-targets)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 About This Project

This repository is a **comprehensive, production-grade DevOps reference** that demonstrates how to build, test, containerize, deploy, and monitor a Flask application on **AWS EKS (Elastic Kubernetes Service)** — following **real-world enterprise practices**.

> **🎓 If you're learning DevOps, this single repository covers every major concept you need to master — from writing your first Dockerfile to setting up multi-environment CI/CD pipelines with monitoring and security.**

### What Makes This Different?

| Feature | This Repo | Typical Tutorials |
|---------|----------|-------------------|
| **Application** | Production-grade with health checks, metrics, tests | Basic "Hello World" |
| **Docker** | Multi-stage, non-root, security-hardened | Single-stage, runs as root |
| **Terraform** | Modular with 3 environments | Single flat file |
| **Kubernetes** | 10+ manifest types with Kustomize overlays | Just deployment + service |
| **Helm** | Complete chart with per-env values | None |
| **CI/CD** | GitHub Actions + Jenkins (5 pipelines) | Single basic pipeline |
| **Monitoring** | Prometheus + Grafana + AlertManager | None |
| **Security** | Trivy, RBAC, NetworkPolicies, Pod Security | None |
| **Documentation** | Architecture, deployment guide, troubleshooting | Basic README |

---

## 📚 DevOps Concepts Covered

<table>
<tr><th>#</th><th>Concept</th><th>Implementation</th><th>Files</th></tr>
<tr><td>1</td><td>🐳 <b>Containerization</b></td><td>Multi-stage Docker builds, .dockerignore</td><td><code>docker/</code></td></tr>
<tr><td>2</td><td>☸️ <b>Container Orchestration</b></td><td>Kubernetes Deployments, Services, Ingress</td><td><code>k8s/</code></td></tr>
<tr><td>3</td><td>🏗️ <b>Infrastructure as Code</b></td><td>Terraform modules (VPC, EKS, ECR)</td><td><code>terraform/</code></td></tr>
<tr><td>4</td><td>🔄 <b>CI/CD Pipelines</b></td><td>GitHub Actions + Jenkins</td><td><code>.github/workflows/</code>, <code>jenkins/</code></td></tr>
<tr><td>5</td><td>⎈ <b>Package Management</b></td><td>Helm charts with templates</td><td><code>helm/</code></td></tr>
<tr><td>6</td><td>🎛️ <b>Configuration Management</b></td><td>Kustomize overlays, ConfigMaps</td><td><code>k8s/overlays/</code></td></tr>
<tr><td>7</td><td>🔐 <b>Secret Management</b></td><td>K8s Secrets, env-based config</td><td><code>k8s/base/secret.yaml</code></td></tr>
<tr><td>8</td><td>📈 <b>Auto-Scaling</b></td><td>HPA (CPU + Memory based)</td><td><code>k8s/base/hpa.yaml</code></td></tr>
<tr><td>9</td><td>🛡️ <b>High Availability</b></td><td>PDB, multi-AZ, anti-affinity</td><td><code>k8s/base/pdb.yaml</code></td></tr>
<tr><td>10</td><td>📊 <b>Monitoring</b></td><td>Prometheus + Grafana</td><td><code>monitoring/</code></td></tr>
<tr><td>11</td><td>🔔 <b>Alerting</b></td><td>AlertManager with routing rules</td><td><code>monitoring/alertmanager/</code></td></tr>
<tr><td>12</td><td>🔍 <b>Security Scanning</b></td><td>Trivy (image + filesystem)</td><td><code>security/trivy-config.yaml</code></td></tr>
<tr><td>13</td><td>👥 <b>RBAC</b></td><td>Roles, RoleBindings, ServiceAccounts</td><td><code>security/rbac.yaml</code></td></tr>
<tr><td>14</td><td>🌐 <b>Network Policies</b></td><td>Zero-trust pod networking</td><td><code>k8s/base/networkpolicy.yaml</code></td></tr>
<tr><td>15</td><td>🔀 <b>GitOps</b></td><td>Branch-based deployments</td><td><code>.github/workflows/cd.yml</code></td></tr>
<tr><td>16</td><td>🔵🟢 <b>Deployment Strategies</b></td><td>Rolling updates, Blue-Green ready</td><td><code>k8s/base/deployment.yaml</code></td></tr>
<tr><td>17</td><td>💾 <b>Remote State</b></td><td>S3 + DynamoDB backend</td><td><code>terraform/backend.tf</code></td></tr>
<tr><td>18</td><td>⚖️ <b>Load Balancing</b></td><td>AWS ALB Ingress Controller</td><td><code>k8s/base/ingress.yaml</code></td></tr>
<tr><td>19</td><td>❤️ <b>Health Checks</b></td><td>Liveness, Readiness, Startup probes</td><td><code>k8s/base/deployment.yaml</code></td></tr>
<tr><td>20</td><td>📝 <b>Structured Logging</b></td><td>Formatted logs with request tracing</td><td><code>app/main.py</code></td></tr>
</table>

---

## 🏗️ Architecture

```
  ┌──────────┐     push      ┌──────────────────────────────────┐
  │Developer │──────────────▶│  GitHub Actions / Jenkins         │
  └──────────┘               │  ┌──────┐ ┌────┐ ┌────┐ ┌─────┐│
                              │  │ Lint │→│Test│→│Scan│→│Build││
                              │  └──────┘ └────┘ └────┘ └──┬──┘│
                              └─────────────────────────────┼───┘
                                                            │
                                                    ┌───────▼──────┐
                                                    │  Amazon ECR   │
                                                    └───────┬──────┘
                                                            │
  ┌─────────────────────────────────────────────────────────▼────────┐
  │                        Amazon EKS Cluster                        │
  │                                                                  │
  │  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────────┐ │
  │  │  Pod (1)  │   │  Pod (2)  │   │  Pod (3)  │   │  Prometheus  │ │
  │  │ Flask App │   │ Flask App │   │ Flask App │   │  + Grafana   │ │
  │  └─────┬────┘   └─────┬────┘   └─────┬────┘   └──────────────┘ │
  │        └───────────────┼──────────────┘                          │
  │                   Service (ClusterIP)                            │
  │                        │                                         │
  │               ┌────────▼────────┐                                │
  │               │  ALB Ingress    │                                │
  │               └────────┬────────┘                                │
  └────────────────────────┼─────────────────────────────────────────┘
                           │
                      ┌────▼─────┐
                      │  Users   │
                      └──────────┘
```

> 📖 **Detailed architecture:** See [docs/architecture.md](docs/architecture.md)

---

## 📁 Project Structure

```
📦 terraform-eks-devops/
│
├── 📂 app/                          # Flask Application (Production-Grade)
│   ├── __init__.py                  # Package init with app factory
│   ├── main.py                      # App factory pattern + logging
│   ├── routes.py                    # API routes + health check endpoints
│   ├── config.py                    # Environment-based configuration
│   └── tests/
│       └── test_app.py              # 20+ unit tests with pytest
│
├── 📂 docker/                       # Containerization
│   ├── Dockerfile                   # Multi-stage, non-root, security-hardened
│   ├── Dockerfile.dev               # Development with hot-reload
│   └── .dockerignore                # Minimize build context
│
├── 📂 terraform/                    # Infrastructure as Code (Modular)
│   ├── modules/
│   │   ├── vpc/                     # VPC with EKS subnet tags
│   │   ├── eks/                     # EKS cluster + managed node groups
│   │   └── ecr/                     # ECR with lifecycle policies
│   ├── environments/
│   │   ├── dev/terraform.tfvars     # Dev: SPOT instances, minimal
│   │   ├── staging/terraform.tfvars # Staging: production-like
│   │   └── prod/terraform.tfvars   # Prod: 3 AZs, larger instances
│   ├── main.tf                      # Root orchestration
│   ├── variables.tf                 # All variables with descriptions
│   ├── outputs.tf                   # Useful outputs + kubectl command
│   ├── provider.tf                  # AWS + K8s + Helm providers
│   └── backend.tf                   # S3 remote state (ready to enable)
│
├── 📂 k8s/                          # Kubernetes Manifests (Kustomize)
│   ├── base/                        # Base manifests
│   │   ├── namespace.yaml           # Namespace isolation
│   │   ├── deployment.yaml          # 3 probe types, security context, anti-affinity
│   │   ├── service.yaml             # ClusterIP service
│   │   ├── ingress.yaml             # AWS ALB with health checks
│   │   ├── hpa.yaml                 # CPU + Memory autoscaling
│   │   ├── pdb.yaml                 # Pod Disruption Budget
│   │   ├── configmap.yaml           # Non-sensitive config
│   │   ├── secret.yaml              # Sensitive config
│   │   ├── networkpolicy.yaml       # Zero-trust networking
│   │   ├── serviceaccount.yaml      # IRSA-ready service account
│   │   └── kustomization.yaml       # Base kustomization
│   └── overlays/
│       ├── dev/                     # Dev: 1 replica, debug logging
│       ├── staging/                 # Staging: 2 replicas
│       └── prod/                    # Prod: 3 replicas, high resources
│
├── 📂 helm/flask-app/              # Helm Chart
│   ├── Chart.yaml                   # Chart metadata
│   ├── values.yaml                  # Default values
│   ├── values-{dev,staging,prod}.yaml # Per-environment overrides
│   └── templates/                   # K8s resource templates
│
├── 📂 .github/workflows/           # GitHub Actions CI/CD
│   ├── ci.yml                       # Lint → Test → Security → Build
│   ├── cd.yml                       # Build → Push → Deploy (dev→staging→prod)
│   └── terraform.yml                # Plan on PR → Apply on merge
│
├── 📂 jenkins/                      # Jenkins Pipeline
│   └── Jenkinsfile                  # Declarative pipeline with parallel stages
│
├── 📂 monitoring/                   # Observability Stack
│   ├── prometheus/                  # Metrics collection configs
│   ├── grafana/                     # Dashboard configs
│   └── alertmanager/                # Alert routing rules
│
├── 📂 security/                     # Security Configurations
│   ├── trivy-config.yaml            # Vulnerability scanner config
│   ├── rbac.yaml                    # Roles & RoleBindings
│   └── pod-security-standards.yaml  # Pod Security Standards
│
├── 📂 scripts/                      # Automation Scripts
│   ├── setup-cluster.sh             # Full cluster setup
│   ├── deploy.sh                    # Deploy (Kustomize or Helm)
│   ├── rollback.sh                  # Rollback with revision selection
│   └── cleanup.sh                   # Teardown with safety prompt
│
├── 📂 docs/                         # Documentation
│   ├── architecture.md              # System architecture
│   ├── deployment-guide.md          # Step-by-step deployment
│   └── troubleshooting.md           # Common issues & fixes
│
├── docker-compose.yml               # Local stack (App+Redis+Prometheus+Grafana)
├── Makefile                         # 25+ developer shortcuts
├── requirements.txt                 # Python dependencies (pinned)
├── pyproject.toml                   # Python tooling config
├── run.py                           # WSGI entrypoint
├── .gitignore                       # Comprehensive gitignore
├── .editorconfig                    # Consistent coding style
├── .env.example                     # Environment variables template
├── CONTRIBUTING.md                  # Contribution guidelines
├── CHANGELOG.md                     # Version history
└── LICENSE                          # MIT License
```

---

## 🛠️ Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **Language** | Python | 3.11 |
| **Framework** | Flask | 3.1.1 |
| **WSGI Server** | Gunicorn | 23.0.0 |
| **Containerization** | Docker | Multi-stage |
| **Orchestration** | Kubernetes (EKS) | 1.29 |
| **IaC** | Terraform | >= 1.5 |
| **Package Mgmt** | Helm | >= 3.x |
| **Config Mgmt** | Kustomize | Built-in |
| **CI/CD** | GitHub Actions + Jenkins | Latest |
| **Monitoring** | Prometheus + Grafana | Latest |
| **Alerting** | AlertManager | Latest |
| **Security** | Trivy | Latest |
| **Cloud** | AWS (EKS, VPC, ECR, IAM, ALB) | - |
| **Testing** | pytest | 8.3.5 |

---

## ✅ Prerequisites

| Tool | Required Version | Install Guide |
|------|-----------------|---------------|
| **AWS CLI** | >= 2.x | [AWS CLI Install](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| **Terraform** | >= 1.5 | [Terraform Install](https://developer.hashicorp.com/terraform/downloads) |
| **Docker** | >= 24.x | [Docker Desktop](https://www.docker.com/products/docker-desktop) |
| **kubectl** | >= 1.28 | [kubectl Install](https://kubernetes.io/docs/tasks/tools/) |
| **Helm** | >= 3.x | [Helm Install](https://helm.sh/docs/intro/install/) |
| **Python** | >= 3.11 | [Python Install](https://python.org/downloads/) |
| **Make** | any | Pre-installed on macOS/Linux |

---

## ⚡ Quick Start

### Local Development (No AWS Required)

```bash
# 1. Clone the repository
git clone https://github.com/DevSars24/terraform-eks-devops.git
cd terraform-eks-devops

# 2. Install dependencies
make install

# 3. Run the Flask app
make run
# → Open http://localhost:5000

# 4. Run tests
make test

# 5. Start the full local stack (App + Redis + Prometheus + Grafana)
make docker-compose-up
# → App:        http://localhost:5000
# → Prometheus: http://localhost:9090
# → Grafana:    http://localhost:3000 (admin/admin)
```

### Deploy to AWS EKS

```bash
# 1. Configure AWS credentials
aws configure

# 2. Provision infrastructure
./scripts/setup-cluster.sh dev

# 3. Deploy the application
./scripts/deploy.sh dev kustomize

# 4. Verify
kubectl get pods -n flask-app-dev
```

> 📖 **Full deployment guide:** See [docs/deployment-guide.md](docs/deployment-guide.md)

---

## 📖 Detailed Guide

### 1. 🐍 Flask Application

The app follows a **production-grade architecture** with:

| Feature | Description |
|---------|-------------|
| **App Factory Pattern** | `create_app()` enables multiple instances and easy testing |
| **Blueprint Architecture** | Modular routes with `api_bp` and `health_bp` |
| **Environment Config** | 4 configs: development, staging, production, testing |
| **Health Endpoints** | `/health` (liveness), `/ready` (readiness), `/metrics` |
| **Structured Logging** | Timestamped, leveled logs with request tracking |
| **Error Handlers** | Consistent JSON error responses for 404, 405, 500 |
| **20+ Unit Tests** | pytest with coverage for all endpoints |

```python
# App factory pattern (app/main.py)
def create_app(config_name=None):
    app = Flask(__name__)
    app.config.from_object(config_by_name[config_name])
    app.register_blueprint(api_bp)
    app.register_blueprint(health_bp)
    return app
```

### 2. 🐳 Docker (Containerization)

**Production Dockerfile highlights:**

```dockerfile
# Multi-stage build — reduces image size by ~60%
FROM python:3.11-slim AS builder    # Stage 1: Install deps
FROM python:3.11-slim AS production # Stage 2: Copy only what's needed

# Security: Non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

# Health check built into Docker
HEALTHCHECK --interval=30s CMD python -c "..."

# Production server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "run:application"]
```

### 3. 🏗️ Terraform (Infrastructure as Code)

**Modular architecture** with 3 reusable modules:

```
terraform/
├── modules/
│   ├── vpc/     # VPC + subnets + NAT Gateway
│   ├── eks/     # EKS cluster + managed node groups + addons
│   └── ecr/     # Container registry + lifecycle policies
├── environments/
│   ├── dev/     # SPOT instances, single NAT, cost-optimized
│   ├── staging/ # ON_DEMAND, production-like
│   └── prod/    # 3 AZs, larger instances, high availability
```

```bash
# Deploy to any environment
terraform plan -var-file=environments/dev/terraform.tfvars
terraform plan -var-file=environments/prod/terraform.tfvars
```

### 4. ☸️ Kubernetes (Orchestration)

**10 manifest types** with **Kustomize** for multi-environment management:

| Manifest | Purpose |
|----------|---------|
| `namespace.yaml` | Resource isolation |
| `deployment.yaml` | App pods with 3 probe types |
| `service.yaml` | Internal load balancing |
| `ingress.yaml` | External access via ALB |
| `hpa.yaml` | Auto-scale on CPU/Memory |
| `pdb.yaml` | Minimum availability guarantee |
| `configmap.yaml` | Non-sensitive configuration |
| `secret.yaml` | Sensitive configuration |
| `networkpolicy.yaml` | Zero-trust networking |
| `serviceaccount.yaml` | IRSA-ready identity |

```bash
# Deploy to different environments with Kustomize
kubectl apply -k k8s/overlays/dev/      # Dev: 1 replica, debug
kubectl apply -k k8s/overlays/staging/  # Staging: 2 replicas
kubectl apply -k k8s/overlays/prod/     # Prod: 3 replicas, high resources
```

### 5. ⎈ Helm (Package Management)

Complete Helm chart with per-environment values:

```bash
# Install for dev
helm install flask-app ./helm/flask-app -f helm/flask-app/values-dev.yaml

# Install for production
helm install flask-app ./helm/flask-app -f helm/flask-app/values-prod.yaml

# Upgrade with new image
helm upgrade flask-app ./helm/flask-app --set image.tag=v2.1.0
```

### 6. 🔄 CI/CD Pipelines

#### GitHub Actions (3 Workflows)

| Workflow | Trigger | Stages |
|----------|---------|--------|
| **CI** (`ci.yml`) | Push/PR | Lint → Test → Security Scan → Docker Build → Terraform Validate |
| **CD** (`cd.yml`) | Push to main | Build → Push ECR → Deploy Dev → Deploy Staging → Deploy Prod |
| **Terraform** (`terraform.yml`) | Push terraform/ | Format → Init → Validate → Plan → Apply |

#### Jenkins Pipeline

Declarative pipeline with parallel stages, ECR push, and Helm deployment.

### 7. 📊 Monitoring & Observability

| Tool | Purpose | Config |
|------|---------|--------|
| **Prometheus** | Metrics collection | `monitoring/prometheus/` |
| **Grafana** | Metrics visualization | `monitoring/grafana/` |
| **AlertManager** | Alert routing & notifications | `monitoring/alertmanager/` |

```bash
# Start monitoring locally
make docker-compose-up
# Prometheus: http://localhost:9090
# Grafana:    http://localhost:3000
```

### 8. 🔒 Security

| Layer | Implementation |
|-------|----------------|
| **Container** | Non-root user, read-only filesystem, minimal base image |
| **Image Scanning** | Trivy in CI pipeline |
| **RBAC** | Least-privilege roles for the application |
| **Network** | NetworkPolicies restricting pod-to-pod traffic |
| **Pod Security** | Pod Security Standards (restricted profile) |
| **Secrets** | K8s Secrets (Sealed Secrets / AWS Secrets Manager ready) |

---

## 🔄 Deployment Strategies

| Strategy | How | Use Case |
|----------|-----|----------|
| **Rolling Update** | `maxSurge: 1, maxUnavailable: 0` | Default, zero-downtime |
| **Blue-Green** | Helm releases with traffic switching | Major version upgrades |
| **Canary** | Multiple Helm releases with weighted routing | Gradual rollout |
| **Rollback** | `./scripts/rollback.sh <env> [revision]` | Emergency recovery |

---

## 🎯 Make Targets

```bash
make help              # Show all available targets

# Local Development
make install           # Install Python dependencies
make run               # Run Flask app locally
make test              # Run tests with coverage
make lint              # Run linters
make format            # Format code with black

# Docker
make docker-build      # Build production image
make docker-run        # Run container locally
make docker-compose-up # Start full local stack

# Kubernetes
make deploy-dev        # Deploy to dev (Kustomize)
make deploy-staging    # Deploy to staging
make deploy-prod       # Deploy to production

# Helm
make helm-install-dev  # Install with Helm (dev)
make helm-install-prod # Install with Helm (prod)
make helm-lint         # Lint Helm chart

# Terraform
make terraform-init    # Initialize Terraform
make terraform-plan    # Plan changes
make terraform-apply   # Apply changes

# Security
make security-scan     # Trivy scan on Docker image
```

---

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit: `git commit -m "feat: add amazing feature"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### ⭐ Star this repo if it helped you learn DevOps!

**Built with ❤️ by [Saurabh Singh Rajput](https://github.com/DevSars24)**

[![GitHub](https://img.shields.io/badge/GitHub-DevSars24-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DevSars24)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/saurabh-singh-rajput-25639a306/)
[![Twitter](https://img.shields.io/badge/X-Follow-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/SaurabhSin15850)

</div>
