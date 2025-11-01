# AI Private Cloud — Terraform + Ansible + Kubernetes

This repository implements a modular private AI inference and training cluster that can start as small as three nodes and scale linearly. It is aimed at lab/presales environments where you want to prove GPU-accelerated workloads on Kubernetes, but still keep everything infrastructure-as-code.

Terraform provisions the compute (OpenStack, XCP-ng, or other), and Ansible configures Kubernetes, GPU operators, and platform services. All automation is runnable from macOS but targets Ubuntu nodes.

## Features

- Terraform-driven provisioning that also writes the Ansible inventory
- Ansible playbook with OS-aware roles (`base-os`, `k8s-control`, `k8s-worker`)
- GPU support for **NVIDIA** (GPU Operator) and **Intel/Habana** (device plugins)
- macOS-safe: localhost is generated as `ansible_become=false`
- Optional platform layer: Argo CD, AI namespaces, KServe/Ollama
- Optional **multi-cloud failover** (AWS EKS → GCP GKE) via Route 53

## Folder Structure

```text
ai-private-cloud/
├── ansible/       # OS + K8s automation (mac-safe)
├── terraform/     # Node provisioning + inventory generation
├── multicloud/    # AWS + GCP failover extension
├── k8s/           # (optional) sample workloads
├── docs/          # diagrams, presales notes (add your Canva/Keynote exports here)
└── .github/       # CI (ansible-lint)
