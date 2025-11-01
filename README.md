# AI Private Cloud — Terraform + Ansible + Kubernetes

This repository defines a modular private AI inference and training cluster that starts small (3 nodes) and can scale linearly. It provisions compute with Terraform and configures Kubernetes + GPU operators with Ansible. All automation can be run from macOS, but it targets Linux (Ubuntu) nodes.

## Features

- Kubernetes install via Ansible (kubeadm control plane + workers)
- GPU support for NVIDIA (GPU Operator) and Intel/Habana (device plugins)
- macOS-safe: tasks detect Darwin and skip Linux-only steps
- Optional platform layer: Argo CD, AI namespaces, KServe/Ollama
- Extensible: multi-cloud failover (see `multicloud/`)

## Folder Structure

```text
ai-private-cloud/
├── ansible/       # OS + K8s automation (mac-safe)
├── terraform/     # Node provisioning + inventory generation
├── k8s/           # Example manifests for GPU workloads
├── docs/          # BOMs / presales notes
└── multicloud/    # AWS + GCP failover extension
