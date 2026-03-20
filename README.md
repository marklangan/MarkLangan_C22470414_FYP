# CI/CD Pipeline on Azure

**Author:** Mark Langan | **Student ID:** C22470414

---

## Overview

A fully automated cloud-native CI/CD pipeline using:

| Layer | Tool |
|---|---|
| Source control | GitHub |
| Pipeline automation | GitHub Actions (self-hosted runner) |
| Containerisation | Docker (multi-stage build) |
| Image registry | Azure Container Registry (ACR) |
| Infrastructure as Code | Terraform |
| Orchestration | Azure Kubernetes Service (AKS) |
| Package management | Helm |
| Vulnerability scanning | Trivy |
| Monitoring | Prometheus + Grafana (kube-prometheus-stack) |

---

## Repository Structure

```
.
├── app/                        # Node.js application
│   ├── index.js
│   ├── app.test.js
│   ├── package.json
│   └── Dockerfile              # Multi-stage build
├── infra/                      # Terraform IaC
│   ├── main.tf
│   ├── providers.tf            # Remote state backend (commented — see setup)
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── bootstrap/
│       └── init-backend.ps1   # Run once to create remote state storage
├── k8s/
│   └── helm/
│       └── fyp-app/            # Helm chart (replaces raw YAML)
│           ├── Chart.yaml
│           ├── values.yaml         # Base values
│           ├── values-dev.yaml     # Dev overrides
│           ├── values-prod.yaml    # Prod overrides (2 replicas, HPA enabled)
│           └── templates/
│               ├── deployment.yaml
│               ├── service.yaml
│               ├── hpa.yaml
│               └── _helpers.tpl
├── monitoring/
│   └── prometheus-values.yaml  # kube-prometheus-stack Helm values
└── .github/
    └── workflows/
        ├── cicd.yml            # Main pipeline (CI → dev → prod)
        └── rollback.yml        # Manual rollback workflow
```

---

## Pipeline Architecture

```
Developer pushes to main
        │
        ▼
┌─────────────────────────────┐
│  JOB 1: CI                  │
│  install → audit → test     │
│  → build → trivy → push ACR │
└─────────────┬───────────────┘
              │ (artifacts: coverage, audit, trivy reports)
              ▼
┌─────────────────────────────┐
│  JOB 2: Deploy → dev        │
│  helm upgrade --install     │
│  namespace: dev             │
│  (automatic)                │
└─────────────┬───────────────┘
              │
              ▼  ← Manual approval gate (GitHub Environment)
┌─────────────────────────────┐
│  JOB 3: Deploy → prod       │
│  helm upgrade --install     │
│  namespace: prod            │
│  (2 replicas, HPA enabled)  │
└─────────────────────────────┘
```

---

## Prerequisites

- Azure CLI: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
- Terraform: https://developer.hashicorp.com/terraform/downloads
- Docker Desktop: https://www.docker.com/products/docker-desktop/
- kubectl: https://kubernetes.io/docs/tasks/tools/
- Helm: https://helm.sh/docs/intro/install/
- Trivy: https://github.com/aquasecurity/trivy/releases/latest
- GitHub Actions self-hosted runner

---

## Setup Guide

### 1. Provision infrastructure

```powershell
az login
terraform init
terraform plan
terraform apply
```

### 2. Connect kubectl

```powershell
az aks get-credentials --resource-group rg-fyp-cicd-fr --name aks-fyp-fr --overwrite-existing
kubectl get nodes
```

### 3. Start the self-hosted runner

```powershell
cd C:\Users\<username>\actions-runner\
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\run.cmd
```

### 4. Deploy monitoring 

```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack `
  --namespace monitoring --create-namespace `
  -f monitoring/prometheus-values.yaml

# Get Grafana external IP
kubectl get svc -n monitoring monitoring-grafana
# Open http://<EXTERNAL-IP>  — login: admin / admin
```

---

## Pipeline Usage

### Normal deployment
Push any change to `main` — the pipeline triggers automatically.

1. CI job builds, tests, scans, and pushes the image
2. Deploy-dev deploys automatically to the `dev` namespace
3. Deploy-prod waits for your manual approval in the GitHub Actions UI

### Manual rollback

Go to Actions → **Rollback Deployment** → Run workflow.  
Select environment (`dev` or `prod`) and optionally a specific Helm revision number.

### View Helm history

```powershell
helm history fyp-app --namespace dev
helm history fyp-app --namespace prod
```

---

## Verification

```powershell
kubectl get nodes
kubectl get deployments -n dev
kubectl get deployments -n prod
kubectl get pods -n dev -o wide
kubectl get pods -n prod -o wide
kubectl get svc -n dev
kubectl get svc -n prod
# Check http://<external-ip>/health
```

Verify image tags in ACR:
```powershell
az acr repository show-tags -n fypcicdregistrymarkl --repository fyp-app -o table
```

---

## Teardown (cost saving)

```powershell
az group delete -n rg-fyp-cicd-fr --yes --no-wait
# Keep rg-fyp-tfstate if you want to preserve Terraform state
```
