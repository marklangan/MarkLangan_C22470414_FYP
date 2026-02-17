# CI/CD Pipeline on Azure

**Author:** Mark Langan
**Student ID:** C22470414

---

## Overview

This project implements a complete **cloud-native CI/CD pipeline** using:

- Terraform (Infrastructure as Code)
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- GitHub Actions (Self-hosted runner)
- Docker (Containerisation)
- Trivy (Container vulnerability scanning)
- Kubernetes (Application orchestration)

The pipeline automatically builds, scans, and deploys a containerised web application to Kubernetes using **immutable deployments tagged with Git commit SHA**, ensuring traceability, reproducibility, and secure delivery.

---

## Architecture

Developer → GitHub Repository
│
▼
GitHub Actions CI/CD Pipeline
│
├── Build Docker Image
├── Scan Image (Trivy)
├── Push Image → Azure Container Registry
└── Deploy → Azure Kubernetes Service
│
▼
Kubernetes Deployment
│
▼
LoadBalancer Service
│
▼
End User

---

## Features

- Infrastructure as Code using Terraform
- Fully automated CI/CD pipeline
- Immutable container deployments using commit SHA tags
- Container vulnerability scanning with Trivy
- Kubernetes readiness and liveness probes
- Secure self-hosted GitHub Actions runner
- Automated deployment verification
- Industry-standard DevOps workflow

---

## Prerequisites

The following tools must be installed before running this project.

---

### 1. Azure CLI

Used to manage Azure infrastructure.

Install:  
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

Verify:

```powershell
az version
```

### 2. Terraform

Used for Infrastructure as Code provisioning.

Install:
https://developer.hashicorp.com/terraform/downloads

Verify:

```powershell
terraform version
```
### 3. Docker Desktop

Used to build and test container images.

Install:
https://www.docker.com/products/docker-desktop/

Verify:

```powershell
docker version
```

### 4. kubectl

Used to manage Kubernetes deployments.

Install:
https://kubernetes.io/docs/tasks/tools/

Verify:

```powershell
kubectl version --client
```
### 5. GitHub Actions Self-Hosted Runner

This project uses a self-hosted runner for secure deployment.

Install guide:
https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners

Recommended location:

C:\Users\<username>\actions-runner\


Start runner:
```powershell
cd C:\Users\<username>\actions-runner\
.\run.cmd
```
Runner must be active before triggering CI/CD pipelines.

### 6. Trivy Vulnerability Scanner

Used to scan container images for vulnerabilities.

Download:
https://github.com/aquasecurity/trivy/releases/latest

Verify:
```powershell
trivy --version
```

### **Infrastructure Deployment**
### **Commands for set up**
```powershell
 az login  #authenticate the CLI to Azure  

cd infra
terraform init
terraform plan
terraform apply

cd ..
az aks update --resource-group {secrets} --name {secrets} --attach-acr {secrets}  #give AKS cluster permission to pull images
az aks get-credentials --resource-group {secret} --name {secret} --overwrite-existing  #allow kubectl to talk to cluster
kubectl get nodes   #verify cluster is alive

az acr login --name fypcicdregistrymarkl

cd app 
docker build -t fypcicdregistrymarkl.azurecr.io/fyp-app:latest .
docker push fypcicdregistrymarkl.azurecr.io/fyp-app:latest

cd ..
cd k8s
kubectl apply -f deployment.yaml #deploy pods
kubectl apply -f service.yaml   # expose app via a Loadbalancer
kubectl get pods
kubectl get svc
```
#new window
```powershell
cd actions-runner
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\run.cmd
```
### **After successful workflow to verify everyhing**
```powershell
az aks get-credentials --resource-group rg-fyp-cicd-fr --name aks-fyp-fr --overwrite-existing # confrim kubectl points to right cluster
kubectl get nodes
kubectl get deployments
kubectl get pods -o wide
kubectl describe pod {pod-name}
kubectl get svc
```
check http://{external-cluster-ip}/health
check tags to verify came from recent workflow
```powershell
az acr repository list -n fypcicdregistrymarkl -o table
az acr repository show-tags -n fypcicdregistrymarkl --repository fyp-app -o table (shows latest commit hash)
```

### **To delete infrastructure for cost-savings when not in use**
```powershell
az group delete -n rg-fyp-cicd-fr --yes --no-wait
az group delete -n MC_rg-fyp-cicd-fr_aks-fyp-fr_francecentral --yes --no-wait
-- and then after 2 - 3 minutes:
az group list -o table
az aks list -o table
az acr list -o table
az vm list -o table
az resource list -o table
```
 verify no output or in status says deleting
