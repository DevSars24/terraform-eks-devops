# Troubleshooting Guide

> **Author:** Saurabh Singh Rajput ([@DevSars24](https://github.com/DevSars24))

## Common Issues

### 1. Pods stuck in `CrashLoopBackOff`

**Symptoms:** Pods keep restarting, never reach `Running` state.

```bash
# Check pod logs
kubectl logs <pod-name> -n flask-app --previous

# Check pod events
kubectl describe pod <pod-name> -n flask-app
```

**Common causes:**
- Application error (check logs)
- Health check failing (verify `/health` endpoint)
- Insufficient resources (increase limits in deployment)
- Missing ConfigMap/Secret

### 2. `ImagePullBackOff` Error

**Cause:** Kubernetes can't pull the Docker image from ECR.

```bash
# Verify ECR login
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com

# Check if image exists
aws ecr describe-images --repository-name flask-eks-devops --region ap-south-1
```

### 3. Terraform State Lock

**Symptoms:** `Error locking state: ConditionalCheckFailedException`

```bash
# Force unlock (use with caution!)
terraform force-unlock <LOCK_ID>
```

### 4. EKS Node Not Ready

```bash
# Check node status
kubectl get nodes -o wide

# Check node conditions
kubectl describe node <node-name>

# Check system pods
kubectl get pods -n kube-system
```

### 5. HPA Not Scaling

**Cause:** Metrics server not installed or not reporting metrics.

```bash
# Check metrics server
kubectl get pods -n kube-system | grep metrics-server

# Check if metrics are available
kubectl top pods -n flask-app

# Install metrics server if missing
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### 6. Ingress Not Working (No External IP)

**Cause:** AWS Load Balancer Controller not installed.

```bash
# Check ingress status
kubectl get ingress -n flask-app

# Check ALB controller
kubectl get pods -n kube-system | grep aws-load-balancer

# Check ingress events
kubectl describe ingress flask-eks-app -n flask-app
```

## Useful Debug Commands

```bash
# Get all resources in a namespace
kubectl get all -n flask-app

# Port-forward for local testing
kubectl port-forward svc/flask-eks-app 5000:80 -n flask-app

# Execute into a pod
kubectl exec -it <pod-name> -n flask-app -- /bin/sh

# View real-time logs
kubectl logs -f -l app.kubernetes.io/name=flask-eks-app -n flask-app

# Check resource usage
kubectl top pods -n flask-app
kubectl top nodes
```
