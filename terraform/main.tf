# ╔══════════════════════════════════════════════════════════════╗
# ║  Root Terraform Configuration                              ║
# ║  Orchestrates all modules: VPC → EKS → ECR                ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "Saurabh Singh Rajput"
    Repository  = "DevSars24/terraform-eks-devops"
  }
}

# ─── VPC Module ───────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
  common_tags          = local.common_tags
}

# ─── EKS Module ──────────────────────────────────────────────
module "eks" {
  source = "./modules/eks"

  cluster_name      = var.cluster_name
  cluster_version   = var.cluster_version
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
  environment       = var.environment
  node_desired_size = var.node_desired_size
  node_max_size     = var.node_max_size
  node_min_size     = var.node_min_size
  instance_types    = var.instance_types
  capacity_type     = var.capacity_type
  common_tags       = local.common_tags
}

# ─── ECR Module ──────────────────────────────────────────────
module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-${var.environment}"
  common_tags     = local.common_tags
}
