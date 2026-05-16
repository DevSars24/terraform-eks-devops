#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  Cleanup Script                                             ║
# ║  Destroy all resources for an environment                   ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

ENVIRONMENT="${1:-dev}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "╔══════════════════════════════════════════════╗"
echo "║  ⚠️  CLEANUP: ${ENVIRONMENT}                ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "This will destroy ALL resources in ${ENVIRONMENT}!"
read -p "Are you sure? (yes/no): " confirm

if [ "${confirm}" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

# ─── Step 1: Delete Kubernetes resources ──────────────────────
echo ""
echo "🗑️  Step 1: Deleting Kubernetes resources..."
NAMESPACE="flask-app-${ENVIRONMENT}"
kubectl delete namespace "${NAMESPACE}" --ignore-not-found=true || true

# ─── Step 2: Destroy Terraform infrastructure ────────────────
echo ""
echo "🏗️  Step 2: Destroying Terraform infrastructure..."
cd "${PROJECT_ROOT}/terraform"
terraform destroy \
    -var-file="environments/${ENVIRONMENT}/terraform.tfvars" \
    -auto-approve

echo ""
echo "✅ Cleanup of ${ENVIRONMENT} complete!"
