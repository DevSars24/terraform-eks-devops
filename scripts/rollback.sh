#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  Rollback Script                                            ║
# ║  Rollback to previous deployment version                    ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

ENVIRONMENT="${1:-dev}"
REVISION="${2:-}"

NAMESPACE="flask-app-${ENVIRONMENT}"
DEPLOYMENT_NAME="${ENVIRONMENT}-flask-eks-app"

echo "╔══════════════════════════════════════════════╗"
echo "║  Rolling back: ${ENVIRONMENT}               ║"
echo "╚══════════════════════════════════════════════╝"

echo ""
echo "📋 Current deployment history:"
kubectl rollout history deployment/"${DEPLOYMENT_NAME}" -n "${NAMESPACE}"

if [ -n "${REVISION}" ]; then
    echo ""
    echo "⏪ Rolling back to revision ${REVISION}..."
    kubectl rollout undo deployment/"${DEPLOYMENT_NAME}" \
        -n "${NAMESPACE}" --to-revision="${REVISION}"
else
    echo ""
    echo "⏪ Rolling back to previous version..."
    kubectl rollout undo deployment/"${DEPLOYMENT_NAME}" -n "${NAMESPACE}"
fi

echo ""
echo "⏳ Waiting for rollback..."
kubectl rollout status deployment/"${DEPLOYMENT_NAME}" \
    -n "${NAMESPACE}" --timeout=300s

echo ""
echo "✅ Rollback complete!"
kubectl get pods -n "${NAMESPACE}"
