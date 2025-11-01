# Multi-Cloud AI Failover (AWS EKS + GCP GKE + Route 53)

This folder extends the base AI private cloud to run in **two clouds** at once and to **fail over** if the primary cloud (AWS) becomes unhealthy.

- **Primary:** AWS EKS (GPU nodes via ASG / node groups)
- **Secondary:** GCP GKE (GPU node pool, e.g. A2)
- **Failover:** AWS Route 53 health checks + failover A records
- **Sync:** Ansible playbook that runs on macOS and applies manifests to both kube contexts

## Structure

```text
multicloud/
├── terraform/
│   ├── aws/            # EKS: cluster + GPU autoscaling group
│   ├── gcp/            # GKE: cluster + GPU node pool
│   └── dns-failover/   # Route 53 health checks + failover records
└── ansible/
    └── site.yml        # kubectl --context=eks / --context=gke apply ...
