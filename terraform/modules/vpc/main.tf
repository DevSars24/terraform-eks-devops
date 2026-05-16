# ╔══════════════════════════════════════════════════════════════╗
# ║  VPC Module                                                 ║
# ║  Creates a production-ready VPC with public/private subnets ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.project_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  # ─── NAT Gateway (Internet access for private subnets) ─────
  enable_nat_gateway   = true
  single_nat_gateway   = var.environment == "dev" ? true : false  # Cost optimization for dev
  enable_dns_hostnames = true
  enable_dns_support   = true

  # ─── EKS Required Tags ─────────────────────────────────────
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster_name}"  = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"            = 1
    "kubernetes.io/cluster/${var.cluster_name}"  = "owned"
  }

  tags = merge(var.common_tags, {
    Module = "vpc"
  })
}
