# AI Private Cloud Infrastructure – Technical Overview

## Purpose
This document describes the architecture, automation flow, and scaling model of the AI Private Cloud project. It corresponds to the private, full version and to the public-safe showcase repository.

## Architecture
- Provisioning (Terraform)
- Configuration (Ansible)
- Orchestration (Kubernetes)
- Multi-cloud / DR (Terraform + DNS)

## Linear Scaling
1. Add nodes in Terraform
2. terraform apply
3. Re-run Ansible
4. GPU operator detects new capacity

## Deployment Flow (reference)
1. terraform init / terraform apply
2. ansible-playbook -i inventories/lab.ini site.yml
3. kubectl apply -f examples/k8s-gpu-operator-sample.yaml

## Links
Public showcase (safe to share):
https://github.com/gravitasse/ai-private-cloud-showcase

\`\`\`bash
terraform init
terraform apply
ansible-playbook -i inventories/lab.ini site.yml
kubectl apply -f examples/k8s-gpu-operator-sample.yaml
\`\`\`


## Table of Contents
- [Purpose](#purpose)
- [Architecture Overview](#architecture-overview)
- [Linear Scaling Model](#linear-scaling-model)
- [Multi-Cloud / Failover Pattern](#multi-cloud--failover-pattern)
- [GPU / NPU Enablement](#gpu--npu-enablement)
- [Deployment Flow (reference)](#deployment-flow-reference)
- [Repository Links](#repository-links)
