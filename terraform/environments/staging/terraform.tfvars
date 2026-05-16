# ╔══════════════════════════════════════════════════════════════╗
# ║  Staging Environment Variables                             ║
# ╚══════════════════════════════════════════════════════════════╝

project_name = "flask-eks-devops"
environment  = "staging"
aws_region   = "ap-south-1"

# VPC
vpc_cidr             = "10.2.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b"]
private_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
public_subnet_cidrs  = ["10.2.101.0/24", "10.2.102.0/24"]

# EKS
cluster_name      = "flask-eks-staging"
cluster_version   = "1.29"
node_desired_size = 2
node_max_size     = 4
node_min_size     = 2
instance_types    = ["t3.medium", "t3.large"]
capacity_type     = "ON_DEMAND"
