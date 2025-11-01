# AI Private Cloud — Terraform + Ansible + Kubernetes

This repository implements a modular private AI inference and training cluster that can start as small as three nodes and scale linearly. It is aimed at lab/presales environments where you want to prove GPU-accelerated workloads on Kubernetes, but still keep everything infrastructure-as-code.

Terraform provisions the compute (OpenStack, XCP-ng, or other), and Ansible configures Kubernetes, GPU operators, and platform services. All automation is runnable from macOS but targets Ubuntu nodes.

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

## Running from macOS

This repo is designed to let you develop on macOS and deploy to Linux:

- \`ansible/inventories/generated/hosts.ini\` → localhost only, no sudo
- \`ansible/inventories/lab.ini\` → real Ubuntu/K8s nodes, with sudo
- Playbooks detect \`ansible_os_family == "Darwin"\` and skip Linux-only tasks

