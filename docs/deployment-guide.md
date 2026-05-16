# Deployment Guide

> **Author:** Saurabh Singh Rajput ([@DevSars24](https://github.com/DevSars24))

## Prerequisites

Before deploying, ensure you have the following tools installed:

| Tool | Version | Installation |
|------|---------|-------------|
| AWS CLI | >= 2.x | `brew install awscli` or [AWS docs](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| Terraform | >= 1.5 | `brew install terraform` or [Terraform docs](https://developer.hashicorp.com/terraform/downloads) |
| Docker | >= 24.x | [Docker Desktop](https://www.docker.com/products/docker-desktop) |
| kubectl | >= 1.28 | `brew install kubectl` or [K8s docs](https://kubernetes.io/docs/tasks/tools/) |
| Helm | >= 3.x | `brew install helm` or [Helm docs](https://helm.sh/docs/intro/install/) |
| Make | any | Pre-installed on macOS/Linux |

## Quick Start (Local Development)

```bash
# 1. Clone the repository
git clone https://github.com/DevSars24/terraform-eks-devops.git
cd terraform-eks-devops

# 2. Install Python dependencies
make install

# 3. Run the app locally
make run

# 4. Run tests
make test

# 5. Start the full stack with Docker Compose
make docker-compose-up

# 6. Access the app
# App:        http://localhost:5000
# Prometheus: http://localhost:9090
# Grafana:    http://localhost:3000 (admin/admin)
```

## AWS Deployment

### Step 1: Configure AWS

```bash
aws configure
# Enter your AWS Access Key, Secret Key, Region (ap-south-1)
```

### Step 2: Provision Infrastructure

```bash
# Option A: Using the setup script
./scripts/setup-cluster.sh dev

# Option B: Using Make
make terraform-init
make terraform-plan
make terraform-apply
```

### Step 3: Deploy Application

```bash
# Option A: Kustomize (recommended for multi-env)
make deploy-dev

# Option B: Helm
make helm-install-dev

# Option C: Using the deploy script
./scripts/deploy.sh dev kustomize
./scripts/deploy.sh dev helm
```

### Step 4: Verify Deployment

```bash
kubectl get pods -n flask-app-dev
kubectl get svc -n flask-app-dev
kubectl get ingress -n flask-app-dev
```

### Step 5: Install Monitoring

```bash
# Add Helm repos
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack \
  -f monitoring/prometheus/prometheus-values.yaml \
  -n monitoring --create-namespace

# Install Grafana
helm install grafana grafana/grafana \
  -f monitoring/grafana/grafana-values.yaml \
  -n monitoring
```

## Rollback

```bash
# Rollback to previous version
./scripts/rollback.sh dev

# Rollback to specific revision
./scripts/rollback.sh dev 3
```

## Cleanup

```bash
# Destroy all resources for an environment
./scripts/cleanup.sh dev
```
