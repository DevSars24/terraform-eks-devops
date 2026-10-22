# ╔══════════════════════════════════════════════════════════════╗
# ║  Remote State Backend Configuration                        ║
# ║  Uses S3 + DynamoDB for state locking                      ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ╚══════════════════════════════════════════════════════════════╝
#
# Backend Configuration Guide:
# ----------------------------
# By default, Terraform uses local state so CI validation and initial setups
# work out-of-the-box without requiring an existing S3 bucket.
#
# To enable remote state storage with S3 and state locking with DynamoDB:
# 1. Create an S3 bucket (e.g., "flask-eks-devops-terraform-state")
# 2. Create a DynamoDB table with LockID (String) partition key
#    (e.g., "flask-eks-devops-terraform-locks")
# 3. Uncomment the backend block below OR provide backend config dynamically via:
#    terraform init -backend-config="bucket=<YOUR_BUCKET>" \
#                   -backend-config="key=eks/terraform.tfstate" \
#                   -backend-config="region=ap-southeast-2" \
#                   -backend-config="dynamodb_table=<YOUR_TABLE>"
#
terraform {
  backend "s3" {
    bucket         = "flask-eks-tfstate-saurabh-991085"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "flask-eks-tf-locks"
  }
}
