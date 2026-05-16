# ╔══════════════════════════════════════════════════════════════╗
# ║  EKS Module                                                ║
# ║  Production-ready EKS cluster with managed node groups     ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # ─── Cluster Access ─────────────────────────────────────────
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # ─── Cluster Addons ─────────────────────────────────────────
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = null
    }
  }

  # ─── Managed Node Groups ───────────────────────────────────
  eks_managed_node_groups = {
    # General purpose node group
    general = {
      name = "${var.cluster_name}-general"

      desired_size = var.node_desired_size
      max_size     = var.node_max_size
      min_size     = var.node_min_size

      instance_types = var.instance_types
      capacity_type  = var.capacity_type  # ON_DEMAND or SPOT

      labels = {
        role        = "general"
        environment = var.environment
      }

      tags = merge(var.common_tags, {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}"  = "owned"
      })
    }
  }

  # ─── Access Configuration ──────────────────────────────────
  enable_cluster_creator_admin_permissions = true

  tags = merge(var.common_tags, {
    Module = "eks"
  })
}
