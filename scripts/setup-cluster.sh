#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  EKS Cluster Setup Script                                   ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─── Configuration ────────────────────────────────────────────
ENVIRONMENT="${1:-dev}"
AWS_REGION="${AWS_REGION:-ap-south-1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "╔══════════════════════════════════════════════╗"
echo "║  Setting up EKS Cluster — ${ENVIRONMENT}    ║"
echo "╚══════════════════════════════════════════════╝"

# ─── Step 1: Terraform Init & Apply ──────────────────────────
echo ""
echo "📦 Step 1: Provisioning infrastructure with Terraform..."
cd "${PROJECT_ROOT}/terraform"
terraform init
terraform plan -var-file="environments/${ENVIRONMENT}/terraform.tfvars" -out=tfplan
terraform apply tfplan

# ─── Step 2: Configure kubectl ───────────────────────────────
echo ""
echo "🔧 Step 2: Configuring kubectl..."
CLUSTER_NAME=$(terraform output -raw cluster_name)
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${AWS_REGION}"

# ─── Step 3: Verify Cluster ─────────────────────────────────
echo ""
echo "✅ Step 3: Verifying cluster..."
kubectl cluster-info
kubectl get nodes

# ─── Step 4: Install Metrics Server (for HPA) ───────────────
echo ""
echo "📊 Step 4: Installing metrics server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml || true

# ─── Step 5: Install AWS Load Balancer Controller ────────────
echo ""
echo "⚖️ Step 5: Installing AWS Load Balancer Controller..."
helm repo add eks https://aws.github.io/eks-charts || true
helm repo update
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName="${CLUSTER_NAME}" \
  --set serviceAccount.create=true || true

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  ✅ Cluster setup complete!                  ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Run: make deploy-${ENVIRONMENT}"
echo "  2. Or:  ./scripts/deploy.sh ${ENVIRONMENT}"
