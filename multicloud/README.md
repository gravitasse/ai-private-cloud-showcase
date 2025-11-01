# Multi-Cloud AI Failover — AWS EKS + GCP GKE + Route 53

This extension adds **cross-cloud failover and redundancy** to the base AI private-cloud platform.  
Primary workloads run on **AWS EKS**, while a standby cluster on **GCP GKE** is kept in sync.  
Failover is handled automatically by AWS Route 53 health checks.

---

## ☁️ Design Goals

| Goal | Description |
|------|--------------|
| High availability | Maintain live inference endpoints even if one provider fails |
| Vendor diversity | Mix NVIDIA (AWS) and Intel (GCP) GPUs |
| IaC parity | Same Terraform modules, parameterized per-cloud |
| Declarative sync | Ansible mirrors manifests across kube contexts |

---

## ⚙️ Components

| Layer | Provider | Tool | Purpose |
|-------|-----------|------|----------|
| Compute | AWS EKS | Terraform | Primary GPU cluster |
| Compute | GCP GKE | Terraform | Secondary cluster |
| DNS | AWS Route 53 | Terraform | Health checks + failover |
| Sync | macOS / CI | Ansible + kubectl | Manifest replication |

---

## 📂 Folder Layout

```text
multicloud/
├── terraform/
│   ├── aws/            # Primary EKS
│   ├── gcp/            # Secondary GKE
│   └── dns-failover/   # Route 53 records + health checks
└── ansible/
    └── site.yml        # Applies workloads to both contexts
eof
eol
