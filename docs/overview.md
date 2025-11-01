# AI Private Cloud – Overview

## Architecture Overview
This section describes the high-level layout of the private AI cloud: control plane, worker/GPU nodes, storage, networking, and ingress. It aligns with the topology diagram in `diagrams/ai-private-cloud-topology.png`.

## Linear Scaling Model
This platform is designed to start from a minimal node count (1–3 nodes) and scale linearly by adding more workers. Terraform provisions infra, Ansible joins new nodes to Kubernetes, and workloads are scheduled automatically.

## Multi-Cloud / Failover Pattern
Primary runs in AWS, secondary in GCP (or other provider). DNS (Route 53) performs health checks on the primary entrypoint and fails over to the secondary cluster. See `diagrams/multicloud-failover.png`.

## GPU / NPU Enablement
Clusters can be equipped with NVIDIA or Intel GPU/NPU plugins. AI workloads (Ollama, Open WebUI, LM Studio-backed services) can request GPU resources via Kubernetes resource requests.

## Deployment Flow (reference)
1. Terraform: provision infra (VMs / instances / network)
2. Ansible: configure OS + install Kubernetes + join nodes
3. Kubernetes: deploy AI services (Ollama, inference APIs, observability)
4. (Optional) Multicloud: enable DNS failover + cross-cloud replication

## Repository Links
- Public showcase (this repo): https://github.com/gravitasse/ai-private-cloud-showcase
- Private implementation: gravitasse/ai-private-cloud (not public)
- Diagrams: [Topology](../diagrams/ai-private-cloud-topology.png), [Multi-Cloud Failover](../diagrams/multicloud-failover.png)
