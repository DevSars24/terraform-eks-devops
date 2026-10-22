# Architecture Overview

> **Author:** Saurabh Singh Rajput ([@DevSars24](https://github.com/DevSars24))

## System Architecture

```
                           ┌─────────────────────────────────────────────┐
                           │              AWS Cloud (ap-southeast-2)     │
                           │                                             │
  ┌──────────┐            │  ┌─────────────────────────────────────┐   │
  │ Developer │────push───▶│  │         GitHub / Jenkins            │   │
  └──────────┘            │  │  ┌─────┐  ┌──────┐  ┌──────────┐  │   │
                           │  │  │ Lint │→│ Test │→│ Build+Push│  │   │
                           │  │  └─────┘  └──────┘  └────┬─────┘  │   │
                           │  └───────────────────────────┼────────┘   │
                           │                              │             │
                           │  ┌───────────────────────────▼────────┐   │
                           │  │              Amazon ECR              │   │
                           │  │        (Container Registry)          │   │
                           │  └───────────────────┬────────────────┘   │
                           │                      │                     │
                           │  ┌───────────────────▼────────────────┐   │
                           │  │           Amazon EKS                │   │
                           │  │  ┌──────────────────────────────┐  │   │
                           │  │  │     Kubernetes Cluster        │  │   │
                           │  │  │                               │  │   │
                           │  │  │  ┌─────┐ ┌─────┐ ┌─────┐   │  │   │
                           │  │  │  │Pod 1│ │Pod 2│ │Pod 3│   │  │   │
                           │  │  │  └──┬──┘ └──┬──┘ └──┬──┘   │  │   │
                           │  │  │     └───────┼───────┘       │  │   │
                           │  │  │          Service (ClusterIP) │  │   │
                           │  │  │             │                │  │   │
                           │  │  │     ┌───────▼──────┐        │  │   │
                           │  │  │     │    Ingress    │        │  │   │
                           │  │  │     │  (AWS ALB)    │        │  │   │
                           │  │  │     └───────┬──────┘        │  │   │
                           │  │  └─────────────┼───────────────┘  │   │
                           │  └────────────────┼───────────────────┘   │
                           │                   │                        │
                           └───────────────────┼────────────────────────┘
                                               │
                                          ┌────▼─────┐
                                          │  Users    │
                                          └──────────┘
```

## Component Breakdown

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Application | Flask (Python) | REST API with health checks |
| Container | Docker (Multi-stage) | Lightweight, secure images |
| Orchestration | Kubernetes (EKS) | Container management |
| Infrastructure | Terraform | Infrastructure as Code |
| CI/CD | GitHub Actions + Jenkins | Automated pipelines |
| Monitoring | Prometheus + Grafana | Metrics & dashboards |
| Security | Trivy, RBAC, NetworkPolicies | Defense in depth |
| Package Mgmt | Helm | Kubernetes deployments |
| Config Mgmt | Kustomize | Environment overlays |

## Networking

- **VPC**: Custom VPC with public/private subnets across 2 AZs (3 in prod)
- **NAT Gateway**: Enables private subnet internet access
- **ALB**: Application Load Balancer for external traffic
- **Network Policies**: Zero-trust pod-to-pod networking
- **Security Groups**: Managed by EKS module

## Deployment Flow

1. Developer pushes code to GitHub
2. CI pipeline: Lint → Test → Security Scan → Docker Build
3. Docker image pushed to Amazon ECR
4. CD pipeline deploys to EKS (dev → staging → prod)
5. Kubernetes manages pod lifecycle, scaling, and health
6. Prometheus scrapes metrics, Grafana visualizes
7. AlertManager notifies on issues
