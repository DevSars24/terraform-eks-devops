# ╔══════════════════════════════════════════════════════════════╗
# ║  Development Environment Variables                         ║
# ╚══════════════════════════════════════════════════════════════╝

project_name = "flask-eks-devops"
environment  = "dev"
aws_region   = "ap-south-1"

# VPC
vpc_cidr             = "10.1.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b"]
private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
public_subnet_cidrs  = ["10.1.101.0/24", "10.1.102.0/24"]

# EKS
cluster_name      = "flask-eks-dev"
cluster_version   = "1.29"
node_desired_size = 2
node_max_size     = 3
node_min_size     = 1
instance_types    = ["t3.medium"]
capacity_type     = "SPOT"  # Cost optimization for dev
