# AI Private Cloud Showcase

This repository is the **public / recruitable** showcase for the private project at `gravitasse/ai-private-cloud`.  
It contains diagrams, sanitized examples, and the high-level description of the platform.

---

## 🚀 AI Private Cloud Multi-Cloud Failover Platform

This project demonstrates a **private AI cloud** architecture for **inference and training workloads**, supporting **multi-cloud redundancy**, **GPU acceleration**, and **Ollama-based LLM deployments** on Kubernetes.

### Key Capabilities
- 🧩 **Terraform + Ansible** – full-stack infrastructure-as-code automation
- ☁️ **AWS (Primary)** & **GCP (Secondary)** – DNS-based failover (Route 53 health checks)
- 🎛️ **Kubernetes GPU clusters** – optimized for AI/ML (NVIDIA + Intel support)
- 🧠 **Ollama integration** – self-hosted LLM inference inside the private cluster
- 🔄 **Model / artifact sync** – replication between clouds for seamless failover
- 📊 **Observability** – Prometheus / Grafana / Loki pattern for monitoring

---

## Architecture Visuals

| AI Private Cloud Topology | Multi-Cloud Failover |
|---------------------------|-----------------------|
| ![AI Private Cloud Topology](diagrams/ai-private-cloud-topology.png) | ![Multi-Cloud Failover](diagrams/multicloud-failover.png) |

---

## Use Cases
- Private AI inference & LLM serving with **data sovereignty**
- Hybrid (on-prem + cloud) model training pipelines
- Zero-downtime **multi-cloud** AI infrastructure
- Self-hosted **Ollama**, **LM Studio**, **Open WebUI** clusters

---

## Related Repos
- Private full implementation (infra + ansible + k8s): **not public**
- Public diagrams & examples: this repo

