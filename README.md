# AWS EKS CI/CD Projects Repository

This repository demonstrates **deployment of applications on AWS EKS** using **Terraform, Docker, Jenkins, Kubernetes, and Helm**. Each project follows **industry-standard best practices** for **CI/CD, Infrastructure as Code (IaC), containerization, and scalable deployments**.

---

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Folder Structure](#folder-structure)  
3. [Scenario 1: Python Flask App Deployment on EKS](#scenario-1-python-flask-app-deployment-on-eks)  
4. [Scenario 2: Blue-Green Deployment for Node.js App](#scenario-2-blue-green-deployment-for-nodejs-app)  
5. [Scenario 3: Multi-Environment Pipeline for Microservices](#scenario-3-multi-environment-pipeline-for-microservices)  
6. [Scenario 4: React Frontend & Node Backend Deployment](#scenario-4-react-frontend--node-backend-deployment)  
7. [Scenario 5: High Availability App Deployment](#scenario-5-high-availability-app-deployment)  
8. [Tech Stack](#tech-stack)  
9. [Prerequisites](#prerequisites)  
10. [Setup Instructions](#setup-instructions)  
11. [CI/CD Pipeline Overview](#cicd-pipeline-overview)  
12. [Security and Best Practices](#security-and-best-practices)  
13. [License](#license)  

---

## Project Overview

This repository contains **end-to-end CI/CD pipelines** for deploying **Python Flask, Node.js, and full-stack React-Node.js applications** on **AWS EKS**. Key features:

- Infrastructure provisioning with **Terraform** (VPC, EKS, ECR)  
- Containerization using **Docker**  
- Deployment orchestration with **Kubernetes** & **Helm**  
- Automated CI/CD pipelines using **Jenkins**  
- Advanced deployment strategies: **Blue-Green**, **multi-environment pipelines**, **high availability with auto-scaling**

---

## Folder Structure

├── README.md
├── terraform/
│ ├── eks/
│ ├── vpc/
│ └── ecr/
├── flask-app/
│ ├── app.py
│ ├── requirements.txt
│ └── Dockerfile
├── node-app/
│ ├── app.js
│ ├── package.json
│ └── Dockerfile
├── react-app/
│ ├── package.json
│ └── Dockerfile
├── jenkins/
│ └── Jenkinsfile
├── k8s/
│ ├── deployment.yaml
│ ├── service.yaml
│ └── hpa.yaml
├── helm/
│ ├── blue/
│ └── green/

yaml
Copy code

---

## Scenario 1: Python Flask App Deployment on EKS

**Objective:** Deploy a Python Flask web service on AWS EKS with automated CI/CD.

**Infrastructure (Terraform):**

```bash
terraform init
terraform plan
terraform apply
Docker Commands:

bash
Copy code
docker build -t flask-app:latest ./flask-app
docker tag flask-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/flask-app:latest
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/flask-app:latest
Kubernetes Deployment:

bash
Copy code
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods -n <namespace>
Jenkins Pipeline Example (Jenkinsfile):

groovy
Copy code
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t flask-app:latest ./flask-app'
            }
        }
        stage('Test') {
            steps {
                sh 'pytest ./flask-app/tests'
            }
        }
        stage('Push to ECR') {
            steps {
                sh 'docker push <ECR_REPO>'
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
            }
        }
    }
}
Scenario 2: Blue-Green Deployment for Node.js App
Objective: Deploy Node.js app using Blue-Green Deployment for zero-downtime.

Commands:

bash
Copy code
# Install Helm apps
helm install blue-app ./helm/blue
helm install green-app ./helm/green

# Upgrade using Jenkins
helm upgrade green-app ./helm/green --set image.tag=latest

# Rollback if needed
helm rollback green-app 1
Scenario 3: Multi-Environment Pipeline for Microservices
Objective: Implement dev, staging, prod environments using Terraform workspaces.

bash
Copy code
terraform workspace new dev
terraform workspace select dev
terraform apply -var="env=dev"
Separate Dockerfiles & Kubernetes manifests per environment

Jenkins pipeline promotes builds dev → staging → prod

Scenario 4: React Frontend & Node Backend Deployment
Objective: Deploy full-stack app with shared CI/CD.

bash
Copy code
# Build frontend
docker build -t react-app ./react-app

# Build backend
docker build -t node-app ./node-app

# Deploy to EKS
kubectl apply -f k8s/react-deployment.yaml
kubectl apply -f k8s/node-deployment.yaml
Jenkins can run parallel builds for frontend & backend

Scenario 5: High Availability App Deployment
Objective: Deploy auto-scaling app on EKS using HPA & Cluster Autoscaler.

bash
Copy code
kubectl apply -f k8s/hpa.yaml
terraform apply -var="enable_autoscaling=true"
kubectl get hpa
kubectl get nodes
Ensures scalability, fault-tolerance, and optimized resource usage

Tech Stack
Cloud: AWS (EKS, VPC, ECR, IAM)

IaC: Terraform

Containerization: Docker

Orchestration: Kubernetes, Helm

CI/CD: Jenkins

Applications: Python Flask, Node.js, React.js

Prerequisites
AWS CLI configured with admin access

Terraform >= 1.5

Docker >= 24

kubectl >= 1.28

Jenkins server with Docker & Kubernetes plugins

Helm >= 3

CI/CD Pipeline Overview
Build Stage: Docker images for app(s)

Test Stage: Run unit tests

Push Stage: Push images to ECR

Deploy Stage: Deploy to EKS using Kubernetes manifests or Helm charts

Promotion & Rollback: Dev → Staging → Prod, Blue-Green deployment supported

Security and Best Practices
IAM Roles: Least privilege access

Secrets Management: AWS Secrets Manager / Kubernetes Secrets

Resource Limits: CPU & memory limits for containers

Auto-scaling: HPA & Cluster Autoscaler enabled

Immutable Deployments: Versioned Docker images

