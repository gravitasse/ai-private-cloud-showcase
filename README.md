# AI Private Cloud Showcase

This repository is the **public showcase** for the private project at `gravitasse/ai-private-cloud`.
It provides architecture diagrams, key design summaries, and a recruiter-safe description of the platform.

---

## 🔧 Recent Updates

### April 2026 (continued) — GCP failover cluster + Ollama/Open WebUI/Qdrant in K8s

- Built GCP Terraform modules (`gcp-network`, `gcp-k8s-cluster`) that mirror the existing AWS modules and complete the multi-cloud failover story — the Route 53 `global-routing` module now has a real GCP cluster to fail over to
- GCP cluster supports GPU worker nodes (`guest_accelerator` + `scheduling.on_host_maintenance = TERMINATE`), static external IP for the K8s API LB, and a service account with least-privilege IAM bindings
- Added `k8s/ollama/` Helm values for the full in-cluster AI inference stack: Ollama (GPU-backed, 100Gi model PVC, llama3.2 pre-pulled), Open WebUI (chat frontend), and Qdrant (vector DB for RAG)
- Added `ansible/roles/platform-apps/tasks/ollama.yml` — deploys all three via Helm with rollout waits; wired into the main platform-apps play after monitoring
- AI workloads now run **inside the K8s cluster**, not just in the `vps-docker/` Docker Compose stack

### April 2026 — Technical audit + full multi-platform hardening

- Full technical accuracy review across Terraform, Ansible, and K8s manifests
- Rewrote all Ansible compute roles to support **Debian/Ubuntu**, **RedHat/Rocky/Alma**, **macOS** (noop), **Windows** (noop), and **container environments** — a single playbook now runs correctly across all target types
- Migrated all module references to FQCN (`ansible.builtin.*`); passes `ansible-lint` at the **production** profile with zero violations
- Fixed Cilium CNI installation to use Helm (the `quick-install.yaml` manifest was removed upstream at v1.14)
- Updated Kubernetes package repos from deprecated `apt.kubernetes.io` to `pkgs.k8s.io/core:/stable:/v1.32`
- Corrected NVIDIA MIG profile config (A100-40GB has 7 compute slices; prior config listed 19)
- Fixed Intel Gaudi NFD node selector label and pinned image to a real published tag
- Fixed `nodeSelector` placement in GPU workload manifests (was inside container spec, not pod spec)
- Fixed Terraform: K8s masters wired to **private** subnets; added missing `private_subnet_cidrs` variable wiring
- All `terraform validate` passes clean across AWS and OpenStack environments

---

## 🚀 AI Private Cloud Multi-Cloud Failover Platform

This project demonstrates a **private AI cloud** architecture for **inference and training workloads**, supporting **multi-cloud redundancy**, **GPU acceleration**, and **Ollama-based LLM deployments** on Kubernetes.

### Key Capabilities

- 🧩 **Terraform + Ansible** – full-stack Infrastructure-as-Code automation
- ☁️ **AWS (Primary)** & **GCP (Secondary)** – Automated Route 53 DNS Failover
- 🎛️ **Kubernetes GPU clusters** – optimized for AI/ML (NVIDIA + Intel/Gaudi support)
- 🧠 **Ollama & Open WebUI** – self-hosted LLM inference and RAG interface
- 🔄 **Modular Storage Layer** – pluggable architecture supporting Longhorn, OpenEBS, and AWS FSx
- 🛡️ **Zero-Trust Hardening** – AWS SSM secure access with strictly private subnets
- 🚀 **VPS Docker Edition** – a lightweight "AI Cloud in a Box" using Docker Compose
- 🐧 **Multi-Platform Ansible** – Debian/Ubuntu, RedHat/Rocky/Alma, macOS, Windows, and container-safe roles

---

## 🧱 Architecture Visuals

![AI Private Cloud Topology](diagrams/ai-private-cloud-topology-v2.png)

![Multi-Cloud Failover](diagrams/multicloud-failover-v2.png)

---

## 💡 Use Cases

- Private AI inference & LLM serving with **data sovereignty**
- Zero-downtime **multi-cloud** AI infrastructure via Route 53 Load Balancing
- Agnostic Enterprise Storage using Longhorn or OpenEBS
- Self-hosted **Ollama**, **n8n**, and **Open WebUI** clusters

---

## 🔗 Related

- Full private codebase: `gravitasse/ai-private-cloud` (private)
- Public diagrams & examples: **this repo**

## Repository Layout (Infra Snapshot)

This repo also includes the skeletal infrastructure code behind the diagrams:

- `terraform/` – HCL modules and environments:
  - `modules/network`, `modules/k8s-cluster`, `modules/global-routing`
  - `envs/dev/aws` plus examples for OpenStack and inventory templating
- `ansible/` – modular inventories, playbooks, and roles:
  - `storage-longhorn`, `storage-openebs`, `storage-aws-fsx`
  - roles for base OS, GPU nodes (NVIDIA + Intel/Gaudi), k8s control-plane/worker nodes, and platform apps
  - all roles support Debian/Ubuntu, RedHat/Rocky/Alma, and macOS/Windows noop guards
  - FQCN (`ansible.builtin.*`) throughout; lint-clean at `ansible-lint` production profile
  - Cilium CNI installed via Helm (v1.16.6); k8s packages from `pkgs.k8s.io/core:/stable:/v1.32`
- `k8s/ollama/` – Helm values for Ollama, Open WebUI, and Qdrant (in-cluster AI inference stack)
- `vps-docker/` – The "AI Cloud in a Box" Docker Compose stack (Ollama + WebUI + n8n)
- `Makefile` – helper targets for running Terraform and Ansible locally
