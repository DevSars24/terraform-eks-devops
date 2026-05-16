#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  Deployment Script                                          ║
# ║  Deploy Flask app to EKS using Kustomize or Helm            ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

ENVIRONMENT="${1:-dev}"
DEPLOY_METHOD="${2:-kustomize}"  # kustomize or helm
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "╔══════════════════════════════════════════════╗"
echo "║  Deploying to: ${ENVIRONMENT}               ║"
echo "║  Method: ${DEPLOY_METHOD}                   ║"
echo "╚══════════════════════════════════════════════╝"

if [ "${DEPLOY_METHOD}" = "kustomize" ]; then
    echo ""
    echo "📦 Deploying with Kustomize..."
    kubectl apply -k "${PROJECT_ROOT}/k8s/overlays/${ENVIRONMENT}/"
    echo ""
    echo "⏳ Waiting for rollout..."
    DEPLOYMENT_NAME="${ENVIRONMENT}-flask-eks-app"
    NAMESPACE="flask-app-${ENVIRONMENT}"
    kubectl rollout status deployment/"${DEPLOYMENT_NAME}" \
        -n "${NAMESPACE}" --timeout=300s

elif [ "${DEPLOY_METHOD}" = "helm" ]; then
    echo ""
    echo "⎈ Deploying with Helm..."
    NAMESPACE="flask-app-${ENVIRONMENT}"
    helm upgrade --install flask-app "${PROJECT_ROOT}/helm/flask-app" \
        -f "${PROJECT_ROOT}/helm/flask-app/values-${ENVIRONMENT}.yaml" \
        --namespace "${NAMESPACE}" \
        --create-namespace \
        --wait \
        --timeout 5m
fi

echo ""
echo "📋 Deployment status:"
kubectl get pods -n "flask-app-${ENVIRONMENT}"
kubectl get svc -n "flask-app-${ENVIRONMENT}"

echo ""
echo "✅ Deployment to ${ENVIRONMENT} complete!"
