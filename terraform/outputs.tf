# ╔══════════════════════════════════════════════════════════════╗
# ║  Root Outputs                                              ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

# ─── VPC Outputs ─────────────────────────────────────────────
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# ─── EKS Outputs ─────────────────────────────────────────────
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_provider_arn" {
  description = "OIDC Provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

# ─── ECR Outputs ─────────────────────────────────────────────
output "ecr_repository_url" {
  description = "ECR repository URL for Docker images"
  value       = module.ecr.repository_url
}

# ─── Kubectl Config Command ─────────────────────────────────
output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
