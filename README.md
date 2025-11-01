# AI Private Cloud (Showcase)

This is a public-safe overview of a modular Terraform + Ansible + Kubernetes architecture for deploying GPU-accelerated AI clusters on private or hybrid infrastructure.

The full automation (with roles, Terraform modules, GPU operators, and multi-cloud failover) lives in a **private repository**. This repo is meant to show the approach, not to expose secrets.

## Architecture Overview

![AI Private Cloud Topology](diagrams/ai-private-cloud-topology.png)

### Layers

| Layer | Function |
|-------|----------|
| Control (macOS) | Runs Terraform + Ansible from a laptop |
| Private Cloud | OpenStack / XCP-ng / on-prem K8s cluster |
| GPU Nodes | NVIDIA + Intel/Habana workers via device plugins |
| Multi-Cloud | Optional AWS ↔ GCP failover using Route 53 |

## Stack

Terraform · Ansible · Kubernetes · OpenStack · AWS EKS · GCP GKE · Argo CD · NVIDIA GPU Operator · Intel Habana

## Examples

See the `examples/` folder for sanitized Terraform, Ansible inventory, and playbook samples.

## Access

Full repo and automations are private and available on request.
