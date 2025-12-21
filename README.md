Multi‑Cloud CI/CD Platform with Terraform, Terragrunt, Jenkins & Kubernetes
A fully automated, production‑grade multi‑cloud DevOps platform designed to deploy applications across AWS, Azure, and GCP using GitOps‑inspired workflows, modular IaC, and enterprise‑level CI/CD pipelines.

<p align="left"> <img src="https://img.shields.io/badge/CI/CD-Jenkins-blue" /> <img src="https://img.shields.io/badge/GitOps-ArgoCD-red" /> <img src="https://img.shields.io/badge/IaC-Terraform-623CE4" /> <img src="https://img.shields.io/badge/Security-Trivy-orange" /> <img src="https://img.shields.io/badge/Code%20Quality-SonarQube-brightgreen" /> <img src="https://img.shields.io/badge/Kubernetes-Multi--Cloud-326CE5" /> <img src="https://img.shields.io/badge/License-MIT-green" /> </p>

This project demonstrates end‑to‑end cloud architecture, infrastructure automation, multi‑pipeline orchestration, and observability — built to showcase real‑world engineering capability and architectural thinking.

# Key Features
## Multi‑Cloud Infrastructure
Deploy infrastructure to AWS, Azure, and GCP

- Modular Terraform codebase

- Terragrunt for DRY, reusable, environment‑aware orchestration

- Remote state management per cloud

- Cloud‑specific IAM/SP/SA authentication

# CI/CD Orchestration (Jenkins)
Automated pipelines triggered by GitHub webhooks

Cloud selection logic (AWS/Azure/GCP)

Multi‑stage pipelines:

- Build

- Test

- Security Scanning

- Containerization

- Deployment

- Monitoring & Rollback

# Containerization & Deployment
Dockerized application builds

- Push to cloud‑native registries (ECR, ACR, GCR)

- Deployment to:

  - EKS (AWS)

  - AKS (Azure)

  - GKE (GCP)

- Supports Helm, Kustomize, or raw manifests

# Observability (Open Source Stack)
Prometheus for metrics

- Grafana for dashboards

- OpenTelemetry for logs, metrics, and traces

- Optional: Loki & Jaeger for full OSS observability

# Security
- SAST scanning

- Dependency scanning

- IaC scanning

- Container image scanning (Trivy)

- SBOM generation

# High‑Level Architecture Diagram

![Architecture Diagram](architecture-img/OIDC%20App.gif)

# Pipeline Breakdown
1. Build Stage
Java application built using Maven/Gradle

Produces JAR/WAR artifact

2. Test Stage
Automated testing with JUnit & Mockito

Integration and unit tests executed via Maven/Gradle

3. Security Stage
SAST scanning

Dependency scanning

IaC scanning

SBOM generation

Container image scanning (Trivy)

4. Containerization Stage
Docker image build

Tagging and versioning

Push to ECR/ACR/GCR

5. Deployment Stage
Deploy to Kubernetes clusters

Multi‑region, multi‑cloud rollout

Canary/rolling strategies supported

6. Monitoring & Rollback
Prometheus metrics

Grafana dashboards

OpenTelemetry traces/logs

Automated rollback on failed health checks

# Infrastructure Structure (Terragrunt)
![Infrastructure Structure](infras-img/OIDC%20App.gif)
Each environment inherits from a shared Terragrunt module, ensuring DRY, reusable, and consistent infrastructure across all clouds.

# Technologies Used
- Infrastructure
- Terraform

- Terragrunt

- AWS / Azure / GCP

- Kubernetes (EKS, AKS, GKE)

# CI/CD
- Jenkins

- GitHub Webhooks

- Docker

- Cloud registries (ECR/ACR/GCR)

# Observability
- Prometheus

- Grafana

- OpenTelemetry

- Loki (optional)

- Jaeger (optional)

# Security
- Trivy

- SAST tools

- IaC scanning

- SBOM generation

# Why This Project Matters
This project demonstrates:

- Multi‑cloud architecture design

- Infrastructure automation at scale

- CI/CD pipeline engineering

- Kubernetes deployment strategies

- Observability and monitoring best practices

- Security‑first DevOps workflows

- Real‑world, enterprise‑grade DevOps engineering

It is designed to showcase architectural thinking, hands‑on engineering, and DevOps leadership.

# How to Use This Repository
- Clone the repo

- Configure cloud credentials

- Run Terragrunt to provision infrastructure

- Push code to GitHub to trigger Jenkins

Watch the full pipeline execute end‑to‑end

View metrics and dashboards in Grafana

# Future Enhancements

- Service mesh (Istio/Linkerd)

- Policy‑as‑Code (OPA/Gatekeeper)

- Multi‑cluster federation

- Cost monitoring dashboards

# Author
Emmanuela Opurum Cloud Solutions Architect & DevOps Engineer Multi‑cloud automation • CI/CD • Kubernetes • Terraform • Terragrunt
