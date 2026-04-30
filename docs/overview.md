# AI Private Cloud – Overview

## Architecture Overview
High-level layout of the private AI cloud: control plane starts with a minimal node count (1–3 nodes) and grows linearly. Infrastructure is provisioned with Terraform, nodes are configured and joined with Ansible, and Kubernetes schedules the GPU workloads.

**Lightweight Alternative:** For users who do not need a full Kubernetes cluster, a platform-agnostic "AI Cloud in a Box" is available in the `vps-docker/` directory. This Docker Compose stack uses Ollama, Open WebUI, and n8n to provide a complete, self-hosted AI platform deployable to a single VPS.
