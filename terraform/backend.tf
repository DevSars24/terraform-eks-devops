# ╔══════════════════════════════════════════════════════════════╗
# ║  Remote State Backend Configuration                        ║
# ║  Uses S3 + DynamoDB for state locking                      ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝

# NOTE: Uncomment this block after creating the S3 bucket and DynamoDB table.
# You can create them manually or use the bootstrap script in scripts/setup-backend.sh

# terraform {
#   backend "s3" {
#     bucket         = "flask-eks-devops-terraform-state"
#     key            = "eks/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "flask-eks-devops-terraform-locks"
#   }
# }
