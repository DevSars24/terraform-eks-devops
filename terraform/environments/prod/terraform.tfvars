# ╔══════════════════════════════════════════════════════════════╗
# ║  Production Environment Variables                          ║
# ╚══════════════════════════════════════════════════════════════╝

project_name = "flask-eks-devops"
environment  = "prod"
aws_region   = "ap-south-1"

# VPC
vpc_cidr             = "10.3.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
private_subnet_cidrs = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
public_subnet_cidrs  = ["10.3.101.0/24", "10.3.102.0/24", "10.3.103.0/24"]

# EKS
cluster_name      = "flask-eks-prod"
cluster_version   = "1.29"
node_desired_size = 3
node_max_size     = 6
node_min_size     = 2
instance_types    = ["t3.large", "t3.xlarge"]
capacity_type     = "ON_DEMAND"
