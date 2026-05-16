# ╔══════════════════════════════════════════════════════════════╗
# ║  Root Variables                                             ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

# ─── Project ──────────────────────────────────────────────────
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "flask-eks-devops"
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

# ─── AWS ──────────────────────────────────────────────────────
variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "ap-south-1"
}

# ─── VPC ──────────────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.101.0/24", "10.1.102.0/24"]
}

# ─── EKS ──────────────────────────────────────────────────────
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "flask-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.29"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Capacity type for node group: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}
