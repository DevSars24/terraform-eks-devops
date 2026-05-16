# ╔══════════════════════════════════════════════════════════════╗
# ║  Makefile — Developer Shortcuts                             ║
# ║  Author: Saurabh Singh Rajput (@DevSars24)                ║
# ║                                                             ║
# ║  Usage: make <target>                                       ║
# ╚══════════════════════════════════════════════════════════════╝

.PHONY: help build test lint run clean docker-build docker-run deploy-dev deploy-staging deploy-prod terraform-plan terraform-apply helm-install

# ─── Default Target ───────────────────────────────────────────
help: ## Show this help message
	@echo ""
	@echo "╔══════════════════════════════════════════════╗"
	@echo "║  Flask EKS DevOps — Make Targets             ║"
	@echo "╚══════════════════════════════════════════════╝"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

# ═══════════════════════════════════════════════════════════════
# LOCAL DEVELOPMENT
# ═══════════════════════════════════════════════════════════════

install: ## Install Python dependencies
	pip install -r requirements.txt

run: ## Run Flask app locally
	FLASK_ENV=development python run.py

test: ## Run unit tests with coverage
	pytest app/tests/ -v --cov=app --cov-report=term-missing

lint: ## Run linters (flake8 + black check)
	flake8 app/ --max-line-length=100 --statistics
	black --check --line-length=100 app/

format: ## Format code with black
	black --line-length=100 app/

clean: ## Clean up temporary files
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	rm -rf .pytest_cache htmlcov .coverage coverage.xml

# ═══════════════════════════════════════════════════════════════
# DOCKER
# ═══════════════════════════════════════════════════════════════

docker-build: ## Build production Docker image
	docker build -t flask-eks-app:latest -f docker/Dockerfile .

docker-build-dev: ## Build development Docker image
	docker build -t flask-eks-app:dev -f docker/Dockerfile.dev .

docker-run: ## Run Docker container locally
	docker run -p 5000:5000 --name flask-app --rm flask-eks-app:latest

docker-compose-up: ## Start full local stack (app + redis + prometheus + grafana)
	docker-compose up -d

docker-compose-down: ## Stop local stack
	docker-compose down -v

# ═══════════════════════════════════════════════════════════════
# KUBERNETES
# ═══════════════════════════════════════════════════════════════

deploy-dev: ## Deploy to dev environment (Kustomize)
	kubectl apply -k k8s/overlays/dev/

deploy-staging: ## Deploy to staging environment (Kustomize)
	kubectl apply -k k8s/overlays/staging/

deploy-prod: ## Deploy to production environment (Kustomize)
	kubectl apply -k k8s/overlays/prod/

# ═══════════════════════════════════════════════════════════════
# HELM
# ═══════════════════════════════════════════════════════════════

helm-install-dev: ## Install/upgrade with Helm (dev)
	helm upgrade --install flask-app ./helm/flask-app \
		-f helm/flask-app/values-dev.yaml \
		--namespace flask-app-dev --create-namespace

helm-install-prod: ## Install/upgrade with Helm (prod)
	helm upgrade --install flask-app ./helm/flask-app \
		-f helm/flask-app/values-prod.yaml \
		--namespace flask-app-prod --create-namespace

helm-lint: ## Lint Helm chart
	helm lint ./helm/flask-app/

helm-template: ## Render Helm templates locally
	helm template flask-app ./helm/flask-app/

# ═══════════════════════════════════════════════════════════════
# TERRAFORM
# ═══════════════════════════════════════════════════════════════

terraform-init: ## Initialize Terraform
	cd terraform && terraform init

terraform-plan: ## Plan Terraform changes (dev)
	cd terraform && terraform plan -var-file=environments/dev/terraform.tfvars

terraform-apply: ## Apply Terraform changes (dev)
	cd terraform && terraform apply -var-file=environments/dev/terraform.tfvars

terraform-destroy: ## Destroy Terraform resources (dev)
	cd terraform && terraform destroy -var-file=environments/dev/terraform.tfvars

terraform-fmt: ## Format Terraform files
	cd terraform && terraform fmt -recursive

# ═══════════════════════════════════════════════════════════════
# SECURITY
# ═══════════════════════════════════════════════════════════════

security-scan: ## Run Trivy security scan on Docker image
	trivy image flask-eks-app:latest --severity HIGH,CRITICAL

security-scan-fs: ## Run Trivy security scan on filesystem
	trivy fs . --severity HIGH,CRITICAL
