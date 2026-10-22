# 📋 `terraform-eks-devops` — The Complete DevOps Guide

> **Author:** Saurabh Singh Rajput ([@DevSars24](https://github.com/DevSars24))
> **Generated:** 2026-07-22
> **Project Type:** Full-Stack DevOps Reference — Flask REST API on AWS EKS with full CI/CD, IaC, Observability & Security

---

## 🎯 What This Document Is

This isn't just a file listing — it's a **self-contained DevOps course** wrapped around one real project. If you read this top to bottom, you should walk away understanding:

- **Why** each tool in the stack exists and what problem it solves
- **How** the pieces connect — from a developer's `git push` to a pod running in production
- **How to deploy** every single layer yourself, step by step
- Enough concepts to hold your own in a DevOps interview or a real production incident

Whether you're a beginner who's never touched Kubernetes, or an engineer who wants a clean reference architecture, this guide is built to take you from **zero to fully deployed**.

---

## 🗺️ Table of Contents

1. [DevOps Concepts Primer](#1-devops-concepts-primer) — the "why" behind every tool
2. [Project Overview](#2-project-overview)
3. [Big Picture Architecture](#3-big-picture-architecture)
4. [Repository Structure](#4-repository-structure)
5. [The Flask Application](#5-the-flask-application)
6. [Containerization with Docker](#6-containerization-with-docker)
7. [Infrastructure as Code — Terraform](#7-infrastructure-as-code--terraform)
8. [Kubernetes Manifests — Kustomize](#8-kubernetes-manifests--kustomize)
9. [Helm Charts](#9-helm-charts)
10. [Kustomize vs Helm — Why Both?](#10-kustomize-vs-helm--why-both)
11. [CI/CD Pipelines](#11-cicd-pipelines)
12. [Observability Stack](#12-observability-stack)
13. [Security Hardening](#13-security-hardening)
14. [Automation Scripts & Makefile](#14-automation-scripts--makefile)
15. [🚀 Full Deployment Guide — Zero to Production](#15--full-deployment-guide--zero-to-production)
16. [Environment Strategy — Dev / Staging / Prod](#16-environment-strategy--dev--staging--prod)
17. [Rollback & Disaster Recovery](#17-rollback--disaster-recovery)
18. [Troubleshooting Playbook](#18-troubleshooting-playbook)
19. [DevOps Glossary](#19-devops-glossary)
20. [Notable Observations & Gaps](#20-notable-observations--gaps)

---

## 1. DevOps Concepts Primer

Before diving into this specific project, let's build the mental model. **DevOps** is the practice of merging software **Dev**elopment and IT **Op**erations so that code moves from a developer's laptop to a live, monitored, secure production system — automatically, safely, and repeatedly.

This project touches **six pillars** of DevOps. Here's what each one means and where it lives in this repo:

```mermaid
mindmap
  root((DevOps<br/>Pillars))
    Infrastructure as Code
      Terraform
      Reproducible AWS infra
    Containerization
      Docker
      Package app + dependencies
    Orchestration
      Kubernetes
      Helm / Kustomize
    CI/CD
      GitHub Actions
      Jenkins
    Observability
      Prometheus
      Grafana
      Alertmanager
    Security
      RBAC
      Trivy
      Pod Security Standards
```

### 1.1 Infrastructure as Code (IaC)
Instead of clicking buttons in the AWS Console to create servers, networks, and clusters, you **write code** that describes the infrastructure. Run that code, and AWS builds exactly what you described. Run it again — nothing changes because it's already correct (this property is called **idempotency**). This project uses **Terraform** for IaC.

### 1.2 Containerization
A container packages your application **plus everything it needs to run** (libraries, runtime, OS files) into a single portable unit. It behaves the same on your laptop, in CI, and in production. This project uses **Docker**.

### 1.3 Orchestration
Once you have containers, you need something to **run many of them reliably** — restart crashed ones, scale up under load, roll out updates without downtime, and route traffic to healthy instances. This is **Kubernetes**. Configuring what Kubernetes should run is done here with **Kustomize** (for dev/staging) and **Helm** (for prod).

### 1.4 CI/CD (Continuous Integration / Continuous Deployment)
- **CI** = every time code is pushed, automatically **build it, test it, and scan it** for problems.
- **CD** = once CI passes, automatically **ship it** to real environments, ideally with safety gates (approvals, smoke tests).

This project implements CI/CD twice — once with **GitHub Actions** (cloud-native) and once with **Jenkins** (self-hosted alternative) — so you can compare both approaches.

### 1.5 Observability
Once your app is live, you need to **see** what it's doing: is it healthy? How much traffic? Any errors? This is done with **metrics** (Prometheus), **dashboards** (Grafana), and **alerts** (Alertmanager).

### 1.6 Security
Every layer needs hardening: containers should run as non-root, Kubernetes access should follow least-privilege (RBAC), and images should be scanned for known vulnerabilities (Trivy) before they ever reach production.

---

## 2. Project Overview

This is a **production-grade DevOps reference project** demonstrating how to build, containerize, and deploy a Python Flask REST API to **AWS Elastic Kubernetes Service (EKS)** using industry best practices.

| Layer | Technology |
|---|---|
| Application | Python 3.11, Flask 3.1.1, Gunicorn |
| Containerization | Docker (multi-stage builds) |
| Infrastructure as Code | Terraform (VPC, EKS, ECR modules) |
| Orchestration | Kubernetes (EKS 1.34) |
| Config Management | Kustomize (dev/staging) + Helm (prod) |
| CI/CD | GitHub Actions + Jenkins |
| Observability | Prometheus + Grafana + Alertmanager |
| Security | Trivy, RBAC, Pod Security Standards, non-root containers |
| Environments | dev / staging / prod |


---

## 3. Big Picture Architecture

This diagram shows **everything** — from developer to production traffic — in one view. Refer back to this as you read the rest of the guide.

```mermaid
flowchart TB
    subgraph DEV["👨‍💻 Developer"]
        Code["git push"]
    end

    subgraph GH["⚙️ GitHub"]
        Repo["Repository"]
        CI["CI Pipeline<br/>lint · test · scan"]
        CD["CD Pipeline<br/>build · push · deploy"]
    end

    subgraph AWS["☁️ AWS Cloud — ap-southeast-2"]
        ECR["📦 ECR<br/>Docker Image Registry"]
        subgraph VPC["🌐 VPC — 10.1.0.0/16"]
            subgraph PUB["Public Subnets"]
                ALB["⚖️ Application Load Balancer"]
            end
            subgraph PRIV["Private Subnets"]
                subgraph EKS["☸️ EKS Cluster — flask-eks (v1.34)"]
                    NODES["Node Group<br/>2× t3.micro"]
                    subgraph NS["Namespace: flask-app-{env}"]
                        PODS["Flask App Pods<br/>Gunicorn 4 workers"]
                        HPA["HPA<br/>auto-scaler"]
                    end
                end
            end
        end
    end

    subgraph OBS["📊 Observability"]
        PROM["Prometheus"]
        GRAF["Grafana"]
        ALERT["Alertmanager"]
    end

    subgraph USER["🌍 End User"]
        Browser["Browser / API Client"]
    end

    Code --> Repo --> CI
    CI -->|"✅ passes"| CD
    CD -->|"docker push"| ECR
    ECR -->|"docker pull"| PODS
    CD -->|"kubectl / helm"| EKS
    Browser --> ALB --> PODS
    PODS -.->|"/metrics"| PROM --> GRAF
    PROM --> ALERT
    HPA -.->|"watches CPU"| PODS
```

### 3.1 Request Lifecycle (Sequence View)

```mermaid
sequenceDiagram
    autonumber
    participant U as 🌍 User
    participant ALB as ⚖️ ALB (Ingress)
    participant SVC as 🔌 K8s Service
    participant POD as 🐳 Flask Pod
    participant PROM as 📊 Prometheus

    U->>ALB: HTTPS request
    ALB->>SVC: Route to flask-app namespace
    SVC->>POD: Load-balance to a healthy pod
    Note over POD: Gunicorn worker handles request
    POD-->>SVC: JSON response
    SVC-->>ALB: Response
    ALB-->>U: Response delivered

    loop Every 15s
        PROM->>POD: Scrape /metrics
        POD-->>PROM: Request count, latency, errors
    end
```

### 3.2 AWS Network Layout

```
AWS Cloud (ap-southeast-2)
├── VPC (10.1.0.0/16)
│   ├── Public Subnets (ap-southeast-2a, ap-southeast-2b)  ← ALB Load Balancer, NAT Gateway
│   └── Private Subnets (ap-southeast-2a, ap-southeast-2b) ← EKS Worker Nodes (no direct internet)
│       └── EKS Cluster: flask-eks (k8s 1.34)
│           ├── Node Group: 2 × t3.micro (ON_DEMAND, max 4)
│           └── Namespaces:
│               ├── flask-app-dev
│               ├── flask-app-staging
│               └── flask-app-prod
│                   ├── Flask App Pods (Gunicorn, 4 workers)
│                   ├── HPA (CPU-based auto-scaling)
│                   ├── PodDisruptionBudget
│                   └── NetworkPolicy
└── ECR: flask-eks-devops-{env}   ← Docker image registry
```

> **Why public + private subnets?** The Load Balancer needs to be reachable from the internet, so it lives in **public** subnets. The actual application pods should **never** be directly reachable from the internet — they live in **private** subnets and only receive traffic routed through the ALB. This is a core AWS security pattern.


---

## 4. Repository Structure

```
terraform-eks-devops/
├── app/                         ← Flask application source code
│   ├── __init__.py
│   ├── config.py
│   ├── main.py
│   ├── routes.py
│   └── tests/
│       ├── __init__.py
│       └── test_app.py
├── docker/                      ← Dockerfiles (prod + dev)
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   └── .dockerignore
├── helm/flask-app/              ← Helm chart for Kubernetes deployment
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values-dev.yaml
│   ├── values-staging.yaml
│   ├── values-prod.yaml
│   └── templates/
│       ├── _helpers.tpl
│       ├── NOTES.txt
│       ├── deployment.yaml
│       ├── hpa.yaml
│       ├── ingress.yaml
│       ├── service.yaml
│       └── serviceaccount.yaml
├── jenkins/
│   └── Jenkinsfile              ← Jenkins declarative pipeline
├── k8s/                         ← Raw Kubernetes manifests (Kustomize)
│   ├── base/                    ← Base manifests for all environments
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── hpa.yaml
│   │   ├── ingress.yaml
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   ├── networkpolicy.yaml
│   │   ├── pdb.yaml
│   │   ├── secret.yaml
│   │   ├── service.yaml
│   │   └── serviceaccount.yaml
│   └── overlays/                ← Per-environment Kustomize patches
│       ├── dev/kustomization.yaml
│       ├── staging/
│       └── prod/kustomization.yaml
├── monitoring/                  ← Monitoring stack configs
│   ├── alertmanager/alertmanager-config.yaml
│   ├── grafana/grafana-values.yaml
│   └── prometheus/
│       ├── prometheus.yml
│       └── prometheus-values.yaml
├── scripts/                     ← Shell automation scripts
│   ├── cleanup.sh
│   ├── deploy.sh
│   ├── rollback.sh
│   └── setup-cluster.sh
├── security/                    ← Kubernetes security configs
│   ├── pod-security-standards.yaml
│   ├── rbac.yaml
│   └── trivy-config.yaml
├── terraform/                   ← AWS Infrastructure as Code
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── environments/
│   │   ├── dev/terraform.tfvars
│   │   ├── staging/
│   │   └── prod/
│   └── modules/
│       ├── ecr/
│       ├── eks/
│       └── vpc/
├── docs/
│   ├── architecture.md
│   ├── deployment-guide.md
│   └── troubleshooting.md
├── .github/workflows/           ← GitHub Actions CI/CD pipelines
│   ├── ci.yml
│   ├── cd.yml
│   └── terraform.yml
├── app.py                       ← Minimal legacy Flask entry point
├── run.py                       ← Production app runner (Gunicorn)
├── docker-compose.yml           ← Local dev stack
├── Makefile                     ← Developer shortcuts
├── requirements.txt             ← Python dependencies
├── pyproject.toml               ← Python project metadata
├── .env.example                 ← Environment variable template
└── README.md
```

### 4.1 How the Folders Relate

```mermaid
flowchart LR
    APP["app/<br/>Source Code"] --> DOCKER["docker/<br/>Containerize it"]
    DOCKER --> TF["terraform/<br/>Provision AWS + EKS"]
    TF --> K8S["k8s/ or helm/<br/>Define what runs"]
    K8S --> MON["monitoring/<br/>Watch it"]
    K8S --> SEC["security/<br/>Lock it down"]
    CI["github/workflows/<br/>or jenkins/"] -->|"automates"| DOCKER
    CI -->|"automates"| K8S
    SCRIPTS["scripts/"] -->|"wraps common commands for"| TF
    SCRIPTS -->|"wraps common commands for"| K8S
```


---

## 5. The Flask Application

The Python app uses the **Application Factory Pattern** — instead of creating the Flask app as a global object, a function `create_app()` builds and returns it. This makes the app easy to test (you can spin up fresh instances) and easy to configure differently per environment.

```mermaid
flowchart TD
    A["run.py<br/>(production entry)"] --> B["create_app()<br/>in app/main.py"]
    C["app.py<br/>(legacy/minimal entry)"] -.->|"kept for backward-compat only"| D["Simple Flask('__main__')"]
    B --> E["Loads Config class<br/>from app/config.py"]
    B --> F["Registers Blueprints<br/>from app/routes.py"]
    B --> G["Registers error handlers"]
    B --> H["Configures logging"]
    E --> I["Returns fully-built Flask app"]
    F --> I
    G --> I
    H --> I
    I --> J["Gunicorn serves the app object"]
```

| File | Purpose |
|------|---------|
| `app/__init__.py` | Package init — exposes `create_app` |
| `app/config.py` | Environment config classes (Dev/Staging/Prod/Testing) — 12-factor app pattern |
| `app/main.py` | Application factory: `create_app()` — registers Blueprints, error handlers, logging |
| `app/routes.py` | All API routes and health check endpoints |
| `app/tests/test_app.py` | `pytest` + `pytest-flask` suite covering routes, health checks, error handlers (404/405/500), metrics |

### 5.1 API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Welcome / landing page |
| GET | `/api/info` | App metadata (version, uptime, platform) |
| GET | `/health` | **Liveness probe** — is the process alive? |
| GET | `/ready` | **Readiness probe** — ready to accept traffic? |
| GET | `/metrics` | In-memory request metrics |

> 💡 **Why separate `/health` and `/ready`?** A process can be *alive* (not crashed) but not *ready* (still loading a config or warming a cache). Kubernetes uses these differently: liveness failures trigger a **restart**, readiness failures just **stop traffic** to that pod without restarting it.

### 5.2 Configuration Classes (12-Factor App Pattern)

```python
BaseConfig        → Shared: SECRET_KEY, APP_NAME, APP_VERSION=2.0.0
DevelopmentConfig → DEBUG=True,  LOG_LEVEL=DEBUG
StagingConfig     → DEBUG=False, LOG_LEVEL=INFO
ProductionConfig  → DEBUG=False, LOG_LEVEL=WARNING (SECRET_KEY must be env var)
TestingConfig     → TESTING=True, DEBUG=True
```

The **12-factor app** principle being followed here: *"store config in environment variables, never hardcode it."* This is exactly why `.env.example` exists as a template, and why `ProductionConfig` refuses to run with a default secret key.

---

## 6. Containerization with Docker

### 6.1 Why Multi-Stage Builds?

A naive Dockerfile installs build tools (compilers, dev headers) directly into the final image — bloating it and increasing attack surface. A **multi-stage build** uses one throwaway stage to compile/install things, then copies only the final artifacts into a clean, minimal final image.

```mermaid
flowchart LR
    subgraph STAGE1["🏗️ Stage 1: builder"]
        A["python:3.11-slim"] --> B["pip install → /install"]
    end
    subgraph STAGE2["📦 Stage 2: production"]
        C["python:3.11-slim (fresh)"] --> D["COPY --from=builder /install"]
        D --> E["Create non-root 'appuser'"]
        E --> F["COPY app source code"]
        F --> G["USER appuser"]
        G --> H["CMD gunicorn ..."]
    end
    STAGE1 -.->|"only compiled packages copied over<br/>— build tools left behind"| STAGE2
```

### 6.2 Files

| File | Purpose |
|------|---------|
| `docker/Dockerfile` | **Multi-stage production image**: Builder stage installs deps, Production stage runs as non-root `appuser` with Gunicorn (4 workers, 2 threads) |
| `docker/Dockerfile.dev` | Development image with hot-reload (Flask dev server) |
| `docker/.dockerignore` | Excludes `.git`, `__pycache__`, `.env`, test files from build context |

### 6.3 Production Dockerfile Highlights
- **Stage 1 (builder):** `python:3.11-slim` — installs packages to `/install`
- **Stage 2 (production):** `python:3.11-slim` — copies only the installed deps, runs as `appuser` (non-root)
- `HEALTHCHECK` uses `urllib.request` to poll `/health` every 30s
- **Gunicorn** binds to `0.0.0.0:5000`, 4 workers × 2 threads, 120s timeout

### 6.4 Building & Running Locally

```bash
# Build the production image
docker build -f docker/Dockerfile -t flask-eks-app:local .

# Run it
docker run -p 5000:5000 --env-file .env flask-eks-app:local

# Verify
curl http://localhost:5000/health
```

### 6.5 `docker-compose.yml` — Full Local Stack

Orchestrates 4 services on a shared `flask-eks-devops-network` bridge:

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| `flask-app` | Built from `Dockerfile.dev` | 5000 | Flask app with hot-reload |
| `redis` | `redis:7-alpine` | 6379 | Cache layer |
| `prometheus` | `prom/prometheus:v2.53.0` | 9090 | Metrics collection |
| `grafana` | `grafana/grafana:11.1.0` | 3000 | Metrics dashboard |

```bash
# Bring up the entire local dev stack in one command
docker-compose up -d

# App:        http://localhost:5000
# Prometheus: http://localhost:9090
# Grafana:    http://localhost:3000
```

```mermaid
flowchart LR
    subgraph NET["flask-eks-devops-network (bridge)"]
        APP["flask-app<br/>:5000"]
        REDIS["redis<br/>:6379"]
        PROM["prometheus<br/>:9090"]
        GRAF["grafana<br/>:3000"]
    end
    APP <--> REDIS
    PROM -->|"scrapes /metrics"| APP
    GRAF -->|"queries"| PROM
    DEV["👨‍💻 You (localhost)"] --> APP
    DEV --> PROM
    DEV --> GRAF
```


---

## 7. Infrastructure as Code — Terraform

Terraform provisions the entire AWS infrastructure in a strict dependency order: **VPC → EKS → ECR**. You never manually create these in the AWS Console — everything is defined in code, versioned in Git, and reproducible.

### 7.1 How Terraform Works (Concept)

```mermaid
flowchart LR
    A["Write .tf files<br/>(desired state)"] --> B["terraform init<br/>downloads providers"]
    B --> C["terraform plan<br/>shows WHAT WILL CHANGE"]
    C --> D{"Looks correct?"}
    D -->|"Yes"| E["terraform apply<br/>makes it real in AWS"]
    D -->|"No"| A
    E --> F["terraform.tfstate<br/>records what now exists"]
    F -.->|"next plan compares against this"| C
```

> 💡 **The state file is everything.** Terraform doesn't ask AWS "what exists?" every time — it trusts its own **state file** as the source of truth. This is why remote state (S3 + DynamoDB locking) matters for teams: if two people apply from different local state files, they'll conflict or overwrite each other's infrastructure.

### 7.2 Module Structure

```mermaid
flowchart TD
    ROOT["terraform/main.tf<br/>(root orchestrator)"]
    ROOT --> VPC["module: vpc"]
    ROOT --> EKS["module: eks"]
    ROOT --> ECR["module: ecr"]

    VPC -->|"outputs: subnet IDs, VPC ID"| EKS
    EKS -->|"outputs: cluster endpoint, OIDC"| ROOT
    ECR -->|"outputs: repository URL"| ROOT

    ROOT --> OUT["terraform/outputs.tf<br/>exposes: cluster endpoint, ECR URL, VPC ID"]
```

| File | Purpose |
|------|---------|
| `terraform/main.tf` | Root orchestrator — calls `vpc`, `eks`, `ecr` modules with `common_tags` |
| `terraform/variables.tf` | Input variables (region, VPC CIDR, EKS version, node sizing) |
| `terraform/outputs.tf` | Exported values (cluster endpoint, ECR URL, VPC ID) |
| `terraform/provider.tf` | AWS + Kubernetes providers configuration |
| `terraform/backend.tf` | S3 + DynamoDB remote state backend (**currently commented out** — requires bootstrap) |

### 7.3 Default Variables (`ap-southeast-2` region)

| Variable | Default |
|----------|---------|
| `aws_region` | `ap-southeast-2` |
| `cluster_name` | `flask-eks` |
| `cluster_version` | `1.34` |
| `vpc_cidr` | `10.1.0.0/16` |
| `node_desired_size` | `2` |
| `node_max_size` | `4` |
| `instance_types` | `["t3.micro"]` |
| `capacity_type` | `ON_DEMAND` |

### 7.4 What Each Module Creates

**🔷 `modules/vpc/`** — the network foundation
- **Public subnets** (with Internet Gateway) — for Load Balancers
- **Private subnets** (with NAT Gateway) — for EKS worker nodes
- Auto-tags subnets for EKS discovery (`kubernetes.io/role/elb`)

**🔷 `modules/eks/`** — the Kubernetes control plane + nodes
- Managed node group (on-demand or SPOT)
- Configurable node sizing (min/desired/max)
- Cluster IAM roles and policies
- Add-ons: CoreDNS, kube-proxy, vpc-cni

**🔷 `modules/ecr/`** — the private Docker registry
- Image scanning on push
- Tag immutability
- Lifecycle policy for image cleanup

### 7.5 🚀 Step-by-Step: Provisioning Infrastructure

```bash
# 1. Bootstrap remote state (ONE-TIME, before anyone else applies)
#    Create an S3 bucket + DynamoDB table manually or via a small bootstrap script,
#    then uncomment terraform/backend.tf and point it at them.

cd terraform

# 2. Initialize — downloads AWS provider, sets up backend
terraform init

# 3. Select environment variables
terraform workspace new dev        # or: staging / prod
terraform plan -var-file=environments/dev/terraform.tfvars

# 4. Review the plan carefully — Terraform shows a diff of what will be created
#    Look for unexpected 'destroy' actions especially!

# 5. Apply
terraform apply -var-file=environments/dev/terraform.tfvars

# 6. Grab the new cluster's kubeconfig
aws eks update-kubeconfig --region ap-southeast-2 --name flask-eks

# 7. Verify connectivity
kubectl get nodes
```

```mermaid
sequenceDiagram
    autonumber
    participant DEV as 👨‍💻 Engineer
    participant TF as 🏗️ Terraform
    participant S3 as 🪣 S3 (state)
    participant AWS as ☁️ AWS API

    DEV->>TF: terraform init
    TF->>S3: Configure remote backend
    DEV->>TF: terraform plan
    TF->>AWS: Read current resource state
    TF-->>DEV: Show diff (add/change/destroy)
    DEV->>TF: terraform apply
    TF->>AWS: Create VPC → EKS → ECR (in order)
    AWS-->>TF: Resources created
    TF->>S3: Write new state
    TF-->>DEV: Outputs (cluster endpoint, ECR URL)
```

> ⚠️ **Destroying infra:** `terraform destroy -var-file=environments/dev/terraform.tfvars` tears everything down. Never run this against `prod` without a second pair of eyes reviewing the plan first.


---

## 8. Kubernetes Manifests — Kustomize

**Kustomize** lets you define a common **base** configuration, then apply small **patches** per environment — without duplicating entire YAML files or using templating syntax.

```mermaid
flowchart TD
    BASE["k8s/base/<br/>10 shared manifests"]
    BASE --> DEV["overlays/dev/<br/>patch: 1 replica, dev image tag"]
    BASE --> STG["overlays/staging/<br/>patch: 2 replicas, staging config"]
    BASE --> PROD["overlays/prod/<br/>patch: prod image tag + namespace"]

    DEV --> DEVOUT["Final manifest for DEV"]
    STG --> STGOUT["Final manifest for STAGING"]
    PROD --> PRODOUT["Final manifest for PROD"]
```

### 8.1 Base Manifests (`k8s/base/`)

| File | Kind | Purpose |
|------|------|---------|
| `namespace.yaml` | Namespace | `flask-app` namespace with resource quotas |
| `deployment.yaml` | Deployment | 2 replicas, rolling update, liveness/readiness/startup probes, non-root security context, pod anti-affinity |
| `service.yaml` | Service | ClusterIP service on port 5000 |
| `ingress.yaml` | Ingress | AWS ALB Ingress Controller routing |
| `hpa.yaml` | HPA | Horizontal Pod Autoscaler (CPU-based) |
| `configmap.yaml` | ConfigMap | App env vars (FLASK_ENV, LOG_LEVEL) |
| `secret.yaml` | Secret | `flask-eks-app-secret` for SECRET_KEY |
| `serviceaccount.yaml` | ServiceAccount | Dedicated SA for least-privilege access |
| `networkpolicy.yaml` | NetworkPolicy | Restricts ingress/egress traffic |
| `pdb.yaml` | PodDisruptionBudget | Ensures minimum available pods during disruptions |
| `kustomization.yaml` | Kustomize | Lists all base resources |

### 8.2 Pod Lifecycle Inside the Deployment

```mermaid
stateDiagram-v2
    [*] --> Pending: Pod scheduled to a node
    Pending --> StartupProbe: Container starts
    StartupProbe --> ContainerRunning: Passes (5s interval, up to 10 failures)
    ContainerRunning --> Ready: Readiness probe passes (every 10s)
    ContainerRunning --> Unhealthy: Liveness probe fails (every 20s)
    Unhealthy --> Restarting: Kubernetes restarts container
    Restarting --> StartupProbe
    Ready --> ServingTraffic: Added to Service endpoints
    ServingTraffic --> Unhealthy: Liveness fails later
    ServingTraffic --> [*]: Pod terminated (rolling update / scale down)
```

### 8.3 Deployment Security Highlights
- `runAsNonRoot: true`, `runAsUser: 1000`
- `readOnlyRootFilesystem: true`
- `allowPrivilegeEscalation: false`
- `capabilities.drop: [ALL]`
- Pod anti-affinity spreads replicas across nodes
- Resources: `100m CPU / 128Mi RAM` requests, `500m / 256Mi` limits
- 3 probes: startup (5s interval, 10 failures), liveness (20s period), readiness (10s period)

### 8.4 🚀 Deploying with Kustomize

```bash
# Preview the fully-rendered manifest before applying (always do this!)
kubectl kustomize k8s/overlays/dev

# Apply to the cluster
kubectl apply -k k8s/overlays/dev/

# Watch the rollout
kubectl rollout status deployment/flask-app -n flask-app-dev

# Same pattern for staging
kubectl apply -k k8s/overlays/staging/
```

| Overlay | What it patches |
|---------|---------------------|
| `dev/` | Dev-specific image tag, replica count, env values |
| `staging/` | Staging-specific patches |
| `prod/` | Production image tag, namespace, and config patches |

---

## 9. Helm Charts

**Helm** is Kubernetes' package manager. Instead of patches over static YAML (like Kustomize), Helm uses **templates** with variables filled in from `values.yaml` files — closer to how you'd template any config with variables.

```mermaid
flowchart LR
    CHART["Chart.yaml<br/>(metadata: name, version)"]
    TEMPLATES["templates/*.yaml<br/>(Go template syntax)"]
    VALUES["values.yaml<br/>(defaults)"]
    OVERRIDE["values-prod.yaml<br/>(overrides)"]

    TEMPLATES -->|"{{ .Values.replicas }}"| RENDER["helm template<br/>renders final YAML"]
    VALUES --> RENDER
    OVERRIDE -->|"-f flag, takes priority"| RENDER
    RENDER --> APPLY["helm install/upgrade<br/>applies to cluster"]
```

### 9.1 Chart Files

| File | Purpose |
|------|---------|
| `helm/flask-app/Chart.yaml` | Chart metadata (name, version, appVersion) |
| `helm/flask-app/values.yaml` | Default values (image, replicas, resources, ingress, HPA) |
| `helm/flask-app/values-dev.yaml` | Dev overrides (1 replica, debug on) |
| `helm/flask-app/values-staging.yaml` | Staging overrides |
| `helm/flask-app/values-prod.yaml` | Prod overrides (3 replicas, HPA enabled) |

### 9.2 Templates

| Template | Kubernetes Resource |
|----------|-------------------|
| `deployment.yaml` | Deployment with probes and security context |
| `service.yaml` | ClusterIP Service |
| `ingress.yaml` | Ingress (conditionally rendered) |
| `hpa.yaml` | Horizontal Pod Autoscaler |
| `serviceaccount.yaml` | ServiceAccount |
| `_helpers.tpl` | Go template helpers (name, labels) |
| `NOTES.txt` | Post-install instructions shown by `helm install` |

### 9.3 🚀 Deploying with Helm

```bash
# Dry-run first — see exactly what would be applied, catch errors early
helm install flask-app ./helm/flask-app \
  -f helm/flask-app/values-prod.yaml \
  --namespace flask-app-prod --create-namespace \
  --dry-run --debug

# Actually install
helm install flask-app ./helm/flask-app \
  -f helm/flask-app/values-prod.yaml \
  --namespace flask-app-prod --create-namespace

# Upgrading an existing release (this is what CD pipelines actually run)
helm upgrade --install flask-app ./helm/flask-app \
  -f helm/flask-app/values-prod.yaml \
  --namespace flask-app-prod \
  --set image.tag=$GIT_SHA

# Check release history (needed for rollbacks — see Section 17)
helm history flask-app -n flask-app-prod
```

---

## 10. Kustomize vs Helm — Why Both?

This project intentionally uses **both** tools, on purpose, so you can see the trade-offs side by side.

```mermaid
flowchart TD
    Q{"Need to deploy?"}
    Q -->|"Simple environment,<br/>few differences from base"| K["Use Kustomize<br/>(dev, staging)"]
    Q -->|"Need packaging, versioning,<br/>reusable public/shared chart,<br/>rollback history"| H["Use Helm<br/>(prod)"]

    K --> KP["✅ No templating language to learn<br/>✅ Plain YAML patches<br/>❌ No built-in release/rollback tracking"]
    H --> HP["✅ Versioned releases + easy rollback<br/>✅ Reusable/shareable chart<br/>❌ Extra templating syntax to learn"]
```

| | Kustomize | Helm |
|---|---|---|
| Syntax | Plain YAML + patches | Go templates + values files |
| Used here for | dev, staging | prod |
| Rollback | Manual (`kubectl rollout undo`) | Built-in (`helm rollback`) |
| Packaging/sharing | Not designed for it | Designed for it (like an npm package) |
| Learning curve | Lower | Slightly higher |

> 🎯 **Interview-ready line:** *"Kustomize is great for lightweight, environment-specific tweaks to shared manifests. Helm shines when you need packaging, versioned releases, and one-command rollbacks — which is exactly why this project uses Kustomize for the lower-risk dev/staging environments and Helm for production."*


---

## 11. CI/CD Pipelines

### 11.1 GitHub Actions — `ci.yml` (Continuous Integration)

Triggers on: `push` to `main`, `develop`, `feature/**` and `pull_request` to `main`, `develop`.

```mermaid
flowchart LR
    TRIGGER["Push / PR"] --> LINT["lint<br/>flake8 + black --check"]
    TRIGGER --> TEST["test<br/>pytest + coverage"]
    TRIGGER --> TFVAL["terraform-validate<br/>fmt + init + validate<br/>(independent)"]
    LINT --> SEC["security<br/>Trivy fs scan + Hadolint"]
    TEST --> SEC
    SEC --> BUILD["docker-build<br/>build image, Trivy scan it<br/>(no push)"]
```

| Job | What it does |
|-----|-------------|
| `lint` | `flake8` (style) + `black --check` (formatting) |
| `test` | `pytest` with coverage report (XML artifact) |
| `security` | Trivy filesystem scan + Hadolint Dockerfile lint |
| `docker-build` | Build image (no push), run Trivy on the built image |
| `terraform-validate` | `terraform fmt -check` + `terraform init -backend=false` + `terraform validate` |

### 11.2 GitHub Actions — `cd.yml` (Continuous Deployment)

Triggers on: `push` to `main`, version tags (`v*`), or manual dispatch.

```mermaid
flowchart LR
    A["build-and-push<br/>Docker build → ECR<br/>Trivy scan (blocks on CRITICAL)"] --> B["deploy-dev<br/>kubectl apply -k overlays/dev<br/>(automatic)"]
    B --> C{"Manual<br/>Approval"}
    C --> D["deploy-staging<br/>kubectl apply -k overlays/staging"]
    D --> E{"Manual<br/>Approval"}
    E --> F["deploy-prod<br/>helm upgrade --install<br/>values-prod.yaml"]
```

| Job | What it does |
|-----|-------------|
| `build-and-push` | Build Docker, push to ECR with SHA/tag, Trivy scan (`exit-code: 1` — blocks on CRITICAL) |
| `deploy-dev` | `kubectl apply -k k8s/overlays/dev/` + rollout status + smoke test |
| `deploy-staging` | `kubectl apply -k k8s/overlays/staging/` (requires GitHub environment approval) |
| `deploy-prod` | `helm upgrade --install` with `values-prod.yaml` (requires GitHub environment approval) |

> **Note:** Dev uses **Kustomize**, staging uses **Kustomize**, prod uses **Helm** — this deliberately mirrors the risk level of each environment (see [Section 10](#10-kustomize-vs-helm--why-both)).

### 11.3 `terraform.yml` — Infrastructure Pipeline

A dedicated pipeline for Terraform: `plan` on pull requests (so reviewers can see infra changes before merging), `apply` on merge to `main`, with state managed remotely.

### 11.4 Full CI → CD Journey

```mermaid
flowchart TD
    Dev["👨‍💻 Developer pushes code"] --> GH["GitHub Actions CI"]
    GH --> Lint["Lint + Format Check"]
    GH --> Test["Unit Tests + Coverage"]
    GH --> Sec["Trivy Security Scan"]
    GH --> TFVal["Terraform Validate"]
    Lint & Test & Sec --> DockerBuild["Docker Build Verification"]
    DockerBuild --> Merge{"Merge to main"}
    Merge --> CD["GitHub Actions CD"]
    CD --> ECR["Build + Push to ECR"]
    ECR --> DevDeploy["Deploy to Dev<br/>kubectl apply -k overlays/dev"]
    DevDeploy --> Smoke["Smoke Test"]
    Smoke --> StagApproval["Manual Approval"]
    StagApproval --> StagDeploy["Deploy to Staging<br/>kubectl apply -k overlays/staging"]
    StagDeploy --> ProdApproval["Manual Approval"]
    ProdApproval --> ProdDeploy["Deploy to Prod<br/>helm upgrade --install"]
    ProdDeploy --> Monitor["Prometheus + Grafana"]
```

### 11.5 Jenkins — Alternative Pipeline (`jenkins/Jenkinsfile`)

A declarative pipeline demonstrating the same CI/CD flow for teams using self-hosted Jenkins instead of GitHub Actions.

```mermaid
flowchart TD
    A["📥 Checkout<br/>checkout scm"] --> B["🔍 Quality Gates<br/>(parallel)"]
    B --> B1["lint: flake8 + black"]
    B --> B2["test: pytest + coverage"]
    B1 & B2 --> C["🐳 Docker Build"]
    C --> D["🔒 Security Scan<br/>Trivy"]
    D --> E{"Branch?"}
    E -->|"main or develop"| F["📦 Push to ECR<br/>AWS ECR login + push"]
    E -->|"other"| STOP["Stop here"]
    F --> G{"Branch == main?"}
    G -->|"yes"| H["🚀 Deploy to EKS<br/>helm upgrade --install"]
```

**Pipeline options:** 10 build log retention, 30-min timeout, timestamps enabled, no concurrent builds (prevents two deploys racing each other).

### 11.6 GitHub Actions vs Jenkins — Comparison

| | GitHub Actions | Jenkins |
|---|---|---|
| Hosting | Managed by GitHub | Self-hosted (you maintain the server) |
| Config | YAML in `.github/workflows/` | Groovy `Jenkinsfile` |
| Best for | Projects already on GitHub, less ops overhead | Enterprises needing custom plugins/on-prem control |
| Secrets | GitHub encrypted secrets | Jenkins credentials store |

### 11.7 Required GitHub Secrets

Configure these secrets in your repository settings (**Settings** → **Secrets and variables** → **Actions** → **Repository secrets**):

| Secret Name | Required | Description | Example / Default |
|-------------|----------|-------------|-------------------|
| `AWS_ACCESS_KEY_ID` | **Yes** | AWS IAM Access Key ID for CI/CD authentication | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | **Yes** | AWS IAM Secret Access Key for CI/CD authentication | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_REGION` | No | Target AWS Region (defaults to `ap-southeast-2` if omitted) | `ap-southeast-2` |

> [!NOTE]
> Ensure the IAM user attached to these credentials has permissions for Amazon EKS, ECR, VPC, EC2, and IAM. Workflows gracefully skip AWS-dependent steps if secrets are absent (e.g. during PRs from external forks).

---

## 12. Observability Stack

> **Why observability matters:** deploying software is only half the job. Once it's live, you need to know **if it's actually working** — before your users tell you it isn't. This project follows the classic **metrics → dashboards → alerts** pipeline.

```mermaid
flowchart LR
    APP["🐳 Flask Pods<br/>expose /metrics"] -->|"scraped every 15s"| PROM["📊 Prometheus<br/>time-series database"]
    PROM -->|"queried by"| GRAF["📈 Grafana<br/>dashboards"]
    PROM -->|"rule evaluation"| RULES["⚠️ Alert Rules<br/>e.g. error rate > 5%"]
    RULES -->|"fires"| ALERT["🔔 Alertmanager"]
    ALERT -->|"routes to"| SLACK["💬 Slack"]
    ALERT -->|"routes to"| EMAIL["📧 Email"]
    HUMAN["👨‍💻 On-call Engineer"] -->|"views"| GRAF
    HUMAN -->|"receives"| SLACK
```

### 12.1 Files

| File | Purpose |
|------|---------|
| `monitoring/prometheus/prometheus.yml` | Prometheus scrape config — targets Flask app `/metrics` endpoint (used by `docker-compose` locally) |
| `monitoring/prometheus/prometheus-values.yaml` | Helm values for deploying Prometheus to Kubernetes (`kube-prometheus-stack` chart) |
| `monitoring/grafana/grafana-values.yaml` | Grafana Helm values — admin password, datasource (Prometheus), dashboard provisioning |
| `monitoring/alertmanager/alertmanager-config.yaml` | Alert routing config — routes to Slack/email receivers |

### 12.2 🚀 Deploying the Monitoring Stack to Kubernetes

```bash
# Add the Prometheus community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install the full stack (Prometheus + Grafana + Alertmanager) using our custom values
helm install monitoring prometheus-community/kube-prometheus-stack \
  -f monitoring/prometheus/prometheus-values.yaml \
  -f monitoring/grafana/grafana-values.yaml \
  --namespace monitoring --create-namespace

# Port-forward to view Grafana locally
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
# Open http://localhost:3000
```

> ⚠️ **Production gap flagged in this repo:** the `/metrics` endpoint currently returns basic in-memory JSON metrics — great for a quick check, but Prometheus expects a specific text-based exposition format. The `prometheus-flask-instrumentator` library (already listed in `requirements.txt`) needs to be wired into `app/main.py` to expose real Prometheus-format metrics for accurate scraping.

### 12.3 Alerting Flow

```mermaid
sequenceDiagram
    autonumber
    participant PROM as 📊 Prometheus
    participant RULE as ⚠️ Alert Rule
    participant AM as 🔔 Alertmanager
    participant ONCALL as 👨‍💻 On-call Engineer

    loop Every scrape interval
        PROM->>PROM: Evaluate rule (e.g. error_rate > 5% for 5m)
    end
    PROM->>RULE: Condition met
    RULE->>AM: Fire alert
    AM->>AM: Group + deduplicate similar alerts
    AM->>ONCALL: Send to Slack/Email
    ONCALL->>PROM: Investigate via Grafana dashboard
```

---

## 13. Security Hardening

Security in this project isn't a single file — it's applied at **every layer**, from the Dockerfile all the way to Kubernetes RBAC. Think of it as concentric rings of defense.

```mermaid
flowchart TD
    subgraph L1["Layer 1: Image"]
        A["Non-root user in Dockerfile"]
        B["Trivy scan blocks CRITICAL CVEs"]
        C["Minimal base image (slim)"]
    end
    subgraph L2["Layer 2: Pod"]
        D["runAsNonRoot: true"]
        E["readOnlyRootFilesystem: true"]
        F["capabilities.drop: [ALL]"]
    end
    subgraph L3["Layer 3: Namespace"]
        G["Pod Security Standards (restricted)"]
        H["NetworkPolicy — restrict traffic"]
    end
    subgraph L4["Layer 4: Cluster Access"]
        I["RBAC — least-privilege Roles"]
        J["Dedicated ServiceAccount per app"]
    end

    L1 --> L2 --> L3 --> L4
```

### 13.1 Files

| File | Purpose |
|------|---------|
| `security/rbac.yaml` | Role + RoleBinding (least-privilege: read ConfigMaps, specific Secret) + ClusterRole for monitoring (read pods/svc/deployments) |
| `security/pod-security-standards.yaml` | Namespace labels enforcing Kubernetes Pod Security Standards (restricted/baseline) |
| `security/trivy-config.yaml` | Trivy scanner configuration for CI vulnerability scans |

### 13.2 Trivy in the Pipeline

```mermaid
flowchart LR
    IMG["Docker image built"] --> SCAN["Trivy Scan"]
    SCAN --> SEV{"Any CRITICAL<br/>vulnerabilities?"}
    SEV -->|"Yes"| BLOCK["❌ Pipeline fails<br/>exit-code: 1"]
    SEV -->|"No"| PASS["✅ Continue to push/deploy"]
```

### 13.3 RBAC — Least Privilege in Practice

```mermaid
flowchart LR
    SA["ServiceAccount:<br/>flask-app-sa"] --> RB["RoleBinding"]
    RB --> ROLE["Role: flask-app-role<br/>✅ get/list ConfigMaps<br/>✅ get specific Secret<br/>❌ nothing else"]
    MON["ServiceAccount:<br/>monitoring-sa"] --> CRB["ClusterRoleBinding"]
    CRB --> CROLE["ClusterRole: monitoring-role<br/>✅ read pods/services/deployments<br/>❌ no write access anywhere"]
```

> 🎯 **Why least-privilege matters:** if an attacker compromises a pod, RBAC limits the blast radius. A pod that can only read its own ConfigMap can't suddenly start deleting other namespaces' Secrets.


---

## 14. Automation Scripts & Makefile

### 14.1 Shell Scripts (`scripts/`)

| Script | Purpose |
|--------|---------|
| `setup-cluster.sh` | Bootstrap: Terraform init, apply, kubeconfig setup, monitoring install |
| `deploy.sh` | Deploy app to a given environment (dev/staging/prod) |
| `rollback.sh` | Rollback Helm release to previous revision |
| `cleanup.sh` | Tear down all resources (Helm uninstall + Terraform destroy) |

```mermaid
flowchart LR
    SETUP["setup-cluster.sh<br/>ONE-TIME"] --> DEPLOY["deploy.sh <env><br/>REPEATED"]
    DEPLOY -->|"something breaks"| ROLLBACK["rollback.sh<br/>AS NEEDED"]
    DEPLOY -.->|"project retired"| CLEANUP["cleanup.sh<br/>FINAL"]
```

### 14.2 Key Makefile Targets

| Command | Description |
|---------|-------------|
| `make install` | Install Python dependencies |
| `make run` | Run app locally |
| `make test` | Run tests with coverage |
| `make lint` | Run flake8 + black check |
| `make format` | Auto-format with black |
| `make docker-build` | Build production Docker image |
| `make docker-compose-up` | Start full local stack |
| `make deploy-dev` | Kustomize deploy to dev |
| `make helm-install-prod` | Helm deploy to production |
| `make terraform-plan` | Terraform plan (dev) |
| `make terraform-apply` | Terraform apply (dev) |
| `make security-scan` | Trivy scan on Docker image |

> 💡 The Makefile exists so nobody has to memorize the full `kubectl`/`helm`/`terraform` commands — `make deploy-dev` is easier to remember (and harder to typo) than `kubectl apply -k k8s/overlays/dev/`.

---

## 15. 🚀 Full Deployment Guide — Zero to Production

This is the **complete, ordered path** from an empty AWS account to a fully running, monitored, production application. Follow it top to bottom.

```mermaid
flowchart TD
    S0["0. Prerequisites"] --> S1["1. Clone repo + install deps"]
    S1 --> S2["2. Run & test locally<br/>(docker-compose up)"]
    S2 --> S3["3. Bootstrap Terraform remote state"]
    S3 --> S4["4. Provision AWS infra<br/>(terraform apply)"]
    S4 --> S5["5. Connect kubectl to new cluster"]
    S5 --> S6["6. Install monitoring stack"]
    S6 --> S7["7. Build & push first Docker image to ECR"]
    S7 --> S8["8. Deploy to DEV<br/>(Kustomize)"]
    S8 --> S9["9. Smoke test DEV"]
    S9 --> S10["10. Promote to STAGING<br/>(Kustomize)"]
    S10 --> S11["11. Promote to PROD<br/>(Helm)"]
    S11 --> S12["12. Verify dashboards + alerts"]
    S12 --> S13["13. Set up CI/CD to automate all of the above"]
```

### Step 0 — Prerequisites

```bash
# Tools you need installed locally
aws --version          # AWS CLI v2
terraform --version    # >= 1.5
kubectl version --client
helm version
docker --version
python3 --version       # 3.11
```

You also need:
- An AWS account with permissions to create VPCs, EKS clusters, IAM roles, and ECR repos
- AWS credentials configured (`aws configure`)
- A GitHub repo with Actions enabled (if setting up CI/CD)

### Step 1 — Clone & Install

```bash
git clone https://github.com/DevSars24/terraform-eks-devops.git
cd terraform-eks-devops
cp .env.example .env       # fill in real values
make install                # pip install -r requirements.txt
```

### Step 2 — Run Locally First

Always verify the app works **before** touching AWS — cheaper and faster to debug locally.

```bash
make test                   # run pytest suite
make run                    # or: docker-compose up -d
curl http://localhost:5000/health
```

### Step 3 — Bootstrap Terraform Remote State

```bash
# Create the S3 bucket + DynamoDB lock table (one-time, do this manually or with a small script)
aws s3api create-bucket --bucket flask-eks-tfstate-<unique-suffix> --region ap-southeast-2 \
  --create-bucket-configuration LocationConstraint=ap-southeast-2
aws dynamodb create-table --table-name flask-eks-tf-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# Then uncomment and fill in terraform/backend.tf with these names
```

### Step 4 — Provision AWS Infrastructure

```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```
*(See [Section 7.5](#75--step-by-step-provisioning-infrastructure) for full detail.)*

### Step 5 — Connect `kubectl`

```bash
aws eks update-kubeconfig --region ap-southeast-2 --name flask-eks
kubectl get nodes    # should list 2 t3.micro nodes
```

### Step 6 — Install Monitoring

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack \
  -f monitoring/prometheus/prometheus-values.yaml \
  -f monitoring/grafana/grafana-values.yaml \
  --namespace monitoring --create-namespace
```

### Step 7 — Build & Push First Image

```bash
# Authenticate Docker to ECR
aws ecr get-login-password --region ap-southeast-2 | \
  docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-southeast-2.amazonaws.com

docker build -f docker/Dockerfile -t flask-eks-app:v1 .
docker tag flask-eks-app:v1 <account-id>.dkr.ecr.ap-southeast-2.amazonaws.com/flask-eks-devops-dev:v1
docker push <account-id>.dkr.ecr.ap-southeast-2.amazonaws.com/flask-eks-devops-dev:v1
```

### Step 8 — Deploy to Dev

```bash
kubectl apply -k k8s/overlays/dev/
kubectl rollout status deployment/flask-app -n flask-app-dev
```

### Step 9 — Smoke Test

```bash
kubectl port-forward -n flask-app-dev svc/flask-app 8080:5000
curl http://localhost:8080/health
curl http://localhost:8080/ready
```

### Step 10 — Promote to Staging

```bash
kubectl apply -k k8s/overlays/staging/
kubectl rollout status deployment/flask-app -n flask-app-staging
```

### Step 11 — Promote to Production (Helm)

```bash
helm upgrade --install flask-app ./helm/flask-app \
  -f helm/flask-app/values-prod.yaml \
  --namespace flask-app-prod --create-namespace \
  --set image.tag=v1
```

### Step 12 — Verify Dashboards & Alerts

```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
# Log in, confirm the Flask dashboard shows live request data
```

### Step 13 — Automate All of the Above with CI/CD

From here on, you stop running these commands manually. Push to `main`, and the `cd.yml` pipeline (see [Section 11](#11-cicd-pipelines)) walks through build → dev → staging (approval) → prod (approval) automatically.


---

## 16. Environment Strategy — Dev / Staging / Prod

```mermaid
flowchart LR
    subgraph DEV["🧪 flask-app-dev"]
        D1["1 replica"]
        D2["Debug ON"]
        D3["Deployed via Kustomize"]
        D4["Auto-deployed on every merge"]
    end
    subgraph STG["🎭 flask-app-staging"]
        S1["2 replicas"]
        S2["Debug OFF"]
        S3["Deployed via Kustomize"]
        S4["Requires manual approval"]
    end
    subgraph PROD["🏭 flask-app-prod"]
        P1["3 replicas + HPA"]
        P2["Debug OFF, LOG_LEVEL=WARNING"]
        P3["Deployed via Helm"]
        P4["Requires manual approval"]
    end

    DEV -->|"promote"| STG -->|"promote"| PROD
```

| | Dev | Staging | Prod |
|---|---|---|---|
| Purpose | Fast iteration, break things freely | Final check before real users | Live traffic |
| Deploy tool | Kustomize | Kustomize | Helm |
| Replicas | 1 | 2 | 3 (+ HPA up to more) |
| Approval gate | None (auto) | Manual | Manual |
| Debug mode | On | Off | Off |
| Node sizing | Smaller | Same as prod-ish | Larger, multi-AZ |

> 🎯 **Why this matters in interviews:** this is a textbook example of a **progressive delivery** strategy — catch problems in low-risk environments before they can ever reach real users, with humans explicitly signing off before each promotion to a higher-risk environment.

---

## 17. Rollback & Disaster Recovery

Things will break in production eventually — the goal isn't to prevent every failure, it's to **recover fast**.

```mermaid
flowchart TD
    ISSUE["🚨 Bad deployment detected"] --> WHERE{"Deployed with?"}
    WHERE -->|"Helm (prod)"| HROLL["helm rollback flask-app <REVISION> -n flask-app-prod"]
    WHERE -->|"Kustomize (dev/staging)"| KROLL["kubectl rollout undo deployment/flask-app -n <namespace>"]
    HROLL --> VERIFY["Verify via /health + Grafana"]
    KROLL --> VERIFY
    VERIFY --> DONE{"Healthy again?"}
    DONE -->|"Yes"| POSTMORTEM["Write postmortem, fix root cause"]
    DONE -->|"No"| ESCALATE["Escalate / scale down bad pods manually"]
```

```bash
# Using the wrapper script
./scripts/rollback.sh prod

# Or manually with Helm
helm history flask-app -n flask-app-prod
helm rollback flask-app <REVISION_NUMBER> -n flask-app-prod

# Or manually with kubectl (for Kustomize-deployed environments)
kubectl rollout history deployment/flask-app -n flask-app-dev
kubectl rollout undo deployment/flask-app -n flask-app-dev
```

### 17.1 Full Teardown (`cleanup.sh`)

```bash
# Removes the Helm release AND destroys the underlying AWS infra
./scripts/cleanup.sh prod
# Equivalent to:
helm uninstall flask-app -n flask-app-prod
cd terraform && terraform destroy -var-file=environments/prod/terraform.tfvars
```

> ⚠️ Only run this when you genuinely want to delete everything — there's no undo for `terraform destroy`.

---

## 18. Troubleshooting Playbook

```mermaid
flowchart TD
    START["Something's wrong"] --> Q1{"Pod won't start?"}
    Q1 -->|"Yes"| A1["kubectl describe pod <name> -n <ns><br/>Check: Events section, image pull errors,<br/>resource limits, security context violations"]
    Q1 -->|"No"| Q2{"Pod running but<br/>not receiving traffic?"}
    Q2 -->|"Yes"| A2["kubectl get endpoints <svc> -n <ns><br/>Check: readiness probe failing?<br/>Selector labels match?"]
    Q2 -->|"No"| Q3{"503 / 504 from ALB?"}
    Q3 -->|"Yes"| A3["Check Ingress controller logs,<br/>target group health in AWS console,<br/>security group rules"]
    Q3 -->|"No"| Q4{"Terraform apply fails?"}
    Q4 -->|"Yes"| A4["Check state lock (DynamoDB),<br/>IAM permissions,<br/>run 'terraform plan' to isolate the resource"]
    Q4 -->|"No"| Q5{"CI pipeline failing?"}
    Q5 -->|"Yes"| A5["Check which job failed —<br/>lint/test = code issue,<br/>security = CVE in image or Dockerfile smell"]
```

### 18.1 Quick Diagnostic Commands

```bash
# Pod-level issues
kubectl get pods -n flask-app-prod
kubectl describe pod <pod-name> -n flask-app-prod
kubectl logs <pod-name> -n flask-app-prod --previous   # logs from BEFORE a crash

# Service/networking issues
kubectl get endpoints flask-app -n flask-app-prod
kubectl get networkpolicy -n flask-app-prod

# Resource pressure
kubectl top pods -n flask-app-prod
kubectl top nodes

# HPA not scaling?
kubectl describe hpa flask-app -n flask-app-prod

# Recent events across the whole namespace, sorted by time
kubectl get events -n flask-app-prod --sort-by='.lastTimestamp'
```

See also `docs/troubleshooting.md` for project-specific known issues.


---

## 19. DevOps Glossary

A quick reference for every term used throughout this document — useful for interview prep or onboarding someone new.

| Term | Plain-English Meaning |
|---|---|
| **IaC (Infrastructure as Code)** | Defining servers/networks in code files instead of clicking around a cloud console |
| **Idempotency** | Running the same operation twice produces the same result, with no extra side effects |
| **Container** | A packaged app + its dependencies, isolated from the host system, portable anywhere |
| **Image vs Container** | An image is the frozen blueprint; a container is a *running instance* of that image |
| **Orchestration** | Automatically managing many containers — restarting, scaling, scheduling them |
| **Pod** | The smallest deployable unit in Kubernetes — one or more containers sharing network/storage |
| **Deployment** | A Kubernetes object that manages a set of identical pod replicas and their rollout strategy |
| **Service** | A stable network address that load-balances traffic to a changing set of pods |
| **Ingress** | Routes external HTTP(S) traffic into the cluster, usually to different services by path/host |
| **ConfigMap** | Non-sensitive key-value config, injected into pods as env vars or files |
| **Secret** | Like a ConfigMap, but for sensitive data (base64-encoded, access-controlled) |
| **HPA (Horizontal Pod Autoscaler)** | Automatically adds/removes pod replicas based on CPU/memory/custom metrics |
| **PDB (PodDisruptionBudget)** | Guarantees a minimum number of pods stay available during voluntary disruptions (upgrades, node drains) |
| **NetworkPolicy** | Firewall rules for pod-to-pod traffic inside the cluster |
| **RBAC** | Role-Based Access Control — who/what can do which actions on which resources |
| **ServiceAccount** | An identity that a pod uses to talk to the Kubernetes API |
| **Liveness Probe** | "Is this container alive?" — failing it triggers a restart |
| **Readiness Probe** | "Is this container ready for traffic?" — failing it removes it from load balancing (no restart) |
| **VPC** | An isolated virtual network inside AWS where your resources live |
| **Subnet (public/private)** | A subdivision of a VPC; public subnets can reach the internet directly, private ones can't |
| **NAT Gateway** | Lets resources in private subnets reach the internet *outbound* only (e.g., to pull packages) |
| **IAM Role** | An AWS identity with permissions, assumed by services (not a person) to perform actions |
| **ECR** | AWS's private Docker image registry |
| **EKS** | AWS's managed Kubernetes service — AWS runs the control plane for you |
| **CI (Continuous Integration)** | Automatically building/testing/scanning code on every push |
| **CD (Continuous Deployment/Delivery)** | Automatically shipping code that passed CI to real environments |
| **Blue-Green / Canary / Rolling** | Different strategies for releasing new versions with minimal downtime/risk |
| **Trivy** | An open-source scanner that finds known vulnerabilities (CVEs) in images/filesystems |
| **Prometheus** | A time-series database that scrapes and stores metrics from your systems |
| **Grafana** | A dashboarding tool that visualizes metrics (commonly from Prometheus) |
| **Alertmanager** | Receives alerts fired by Prometheus rules and routes them (Slack, email, PagerDuty, etc.) |
| **12-Factor App** | A set of best practices for building portable, config-driven cloud-native apps |
| **Terraform State** | A file that records what infrastructure Terraform believes currently exists |
| **Helm Release** | A named, versioned deployment of a Helm chart into a cluster |
| **Kustomize Overlay** | A patch applied on top of a shared base configuration for a specific environment |

---

## 20. Notable Observations & Gaps

> [!NOTE]
> **Dual entry points:** `app.py` (root, minimal/legacy) vs `app/main.py` (full factory pattern). Only `app/main.py` + `run.py` should be used in production.

> [!WARNING]
> **Terraform backend is commented out** in `backend.tf`. Remote state (S3 + DynamoDB) must be bootstrapped before team collaboration or CI/CD applies Terraform — see [Step 3 of the deployment guide](#step-3--bootstrap-terraform-remote-state).

> [!NOTE]
> **`/metrics` endpoint** exposes standard Prometheus exposition format powered by `prometheus-flask-exporter` (configured in `app/main.py`), ready for automatic scraping by Prometheus and `ServiceMonitor`.

> [!TIP]
> **Kustomize for dev/staging, Helm for prod** — this split is intentional but worth documenting to avoid confusion during onboarding (see [Section 10](#10-kustomize-vs-helm--why-both)).

> [!NOTE]
> **`monitoring/prometheus/prometheus.yml`** is used by `docker-compose` locally. For Kubernetes, `prometheus-values.yaml` is the Helm values file for the `kube-prometheus-stack` chart.

---

## 📦 Python Dependencies Reference

| Package | Version | Purpose |
|---------|---------|---------|
| `flask` | 3.1.1 | Web framework |
| `gunicorn` | 23.0.0 | Production WSGI server |
| `prometheus-flask-exporter` | 0.23.2 | Standard Prometheus metrics exporter for Flask |
| `flask-cors` | 5.0.1 | Cross-Origin Resource Sharing |
| `pytest` | 8.3.5 | Test runner |
| `pytest-cov` | 6.1.1 | Coverage reporting |
| `pytest-flask` | 1.3.0 | Flask test helpers |
| `flake8` | 7.2.0 | Python linter |
| `black` | 25.1.0 | Code formatter |

---

## 📚 Further Reading in This Repo

| Doc | Content |
|------|---------|
| `docs/architecture.md` | System architecture diagram, component descriptions, data flow |
| `docs/deployment-guide.md` | Step-by-step deployment instructions |
| `docs/troubleshooting.md` | Common issues and fixes |
| `CHANGELOG.md` | Version history |
| `CONTRIBUTING.md` | Contribution guidelines |
| `LICENSE` | MIT License |

---

<div align="center">

**`terraform-eks-devops`** — a single project, six DevOps pillars, one comprehensive guide.

*Report generated by scanning all 60+ files across 12 directories.*

</div>
