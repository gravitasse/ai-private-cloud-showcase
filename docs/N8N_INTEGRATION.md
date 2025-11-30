# n8n Integration – AI Private Cloud Control Plane

_Last updated: 2025-11-28_  
_Repo: `ai-private-cloud` (private implementation)_

This document describes **how n8n fits into the AI Private Cloud project** as the
event-driven orchestration layer on top of:

- **Terraform** – infrastructure and cluster provisioning
- **Ansible** – host, Kubernetes, and GPU configuration
- **Kubernetes** – application and platform workloads (monitoring, ingress, etc.)

The goal is:

> Use n8n as a *visual control plane* that can trigger and coordinate Terraform
> and Ansible workflows, with approvals and notifications, without hiding or
> replacing the underlying IaC.

---

## 1. High-Level Architecture

### 1.1 Layers

1. **Infrastructure / Platforms**
   - VMware vSphere
   - OpenStack
   - XCP-ng
   - Bare metal
   - Public clouds: AWS, GCP (and optionally Azure)

2. **Cluster Orchestrator**
   - Kubernetes running on:
     - vSphere / OpenStack / XCP-ng / bare metal
     - AWS EKS / GCP GKE (and possibly Azure AKS)

3. **Control Plane Tools**
   - **Terraform**
     - Creates VPCs, networks, subnets
     - Provisions VMs and/or managed K8s clusters
     - Emits outputs for downstream tools (IPs, hostnames, kubeconfig, etc.)
   - **Ansible**
     - Configures OS baseline and users
     - Installs Kubernetes (kubeadm, containerd, CNI)
     - Installs GPU drivers (NVIDIA / Intel), storage agents, and node-local services
   - **Kubernetes**
     - Runs application workloads and platform components (monitoring, ingress, gateways)
   - **n8n**
     - Orchestrates workflows around Terraform, Ansible, and Kubernetes:
       - GitOps-style flows
       - Self-service “provision a new dev cluster”
       - Health checks and automated remediation
       - Notifications and approvals

---

## 2. n8n’s Responsibilities

### 2.1 What n8n DOES

- Orchestrates **workflows** that call Terraform/Ansible/K8s:
  - Calls CLI commands via SSH or local shell
  - Sends/receives HTTP webhooks (GitHub, Prometheus, etc.)
  - Coordinates approvals (human-in-the-loop) before destructive changes
  - Publishes results to Slack/Discord/email

- Provides a small “control panel” UI:
  - Buttons / forms to:
    - Plan/apply infrastructure changes
    - Bootstrap or reconfigure a cluster
    - Run targeted Ansible playbooks (e.g., update GPU drivers)

### 2.2 What n8n does NOT do

- It does **not** hold authoritative infrastructure definitions:
  - All infra stays in Terraform (`terraform/`).
  - All configuration stays in Ansible (`ansible/`) and K8s manifests (`k8s/` in the future).

- It does **not** bypass Git:
  - Terraform and Ansible changes are still committed and reviewed in GitHub.
  - n8n is used to *execute* workflows, not to store their source of truth.

---

## 3. Example Workflows

> These are **design examples**, not fully implemented yet. They define the
> direction for future n8n workflows.

### 3.1 GitHub → Terraform Plan → Approval → Apply → Ansible

**Trigger:**

- GitHub push to `main` or to a specific infra branch

**n8n Flow:**

1. Receive GitHub webhook.
2. Run `terraform plan` for the relevant environment:
   - Example (local, direct CLI call):

     ```bash
     cd ~/projects/ai-private-cloud
     terraform -chdir=terraform/envs/dev/aws plan -var-file="terraform.tfvars"
     ```

3. Capture `terraform plan` output (stdout) and attach to the workflow run.
4. Send plan summary to Slack/Discord/Email with an **“Approve / Reject”** link.
5. On approval:
   - Run `terraform apply` with the same parameters:

     ```bash
     cd ~/projects/ai-private-cloud
     terraform -chdir=terraform/envs/dev/aws apply -var-file="terraform.tfvars" -auto-approve
     ```

6. After successful `apply`, trigger an Ansible run:
   - Example:

     ```bash
     cd ~/projects/ai-private-cloud
     ansible-playbook ansible/playbooks/bootstrap.yml
     ansible-playbook ansible/playbooks/k8s-cluster.yml
     ```

7. Notify success or failure with logs and links back to the n8n execution.

**Notes:**

- Environment (dev/test/prod) selection can be driven by:
  - Branch name
  - Labels in the GitHub event
  - A small JSON config n8n reads

---

### 3.2 Self-Service “Provision a New Dev Cluster”

**Trigger:**

- Manual execution from n8n UI (button or form)

**Inputs:**

- Environment name (e.g., `dev-01`)
- Cloud/provider (e.g., `vmware`, `openstack`, `aws`, `gcp`)
- Node counts, instance types, GPU vs non-GPU

**n8n Flow:**

1. Validate the request and log it.
2. Optionally open an issue / ticket (GitHub, Jira) for traceability.
3. Run Terraform to create infra in the selected environment:
   - Calls the appropriate env (e.g., `terraform/envs/dev/aws` vs `terraform/openstack`).
4. Wait for Terraform to finish.
5. Run Ansible:
   - `bootstrap.yml` for base OS
   - `k8s-cluster.yml` for control-plane + workers
   - `gpu-nodes.yml` for GPU driver setup
6. Optionally deploy a baseline K8s platform stack (monitoring, ingress).
7. Return cluster connection details (kubeconfig / kube API URL) to the requester.

---

### 3.3 Health Check and Auto-Remediation

**Trigger:**

- Scheduled (e.g., every 15 minutes)
- Or via Prometheus/Alertmanager webhook

**n8n Flow:**

1. Call Kubernetes API (or Prometheus endpoint) to get:
   - Node status
   - Pod health
   - GPU metrics (via DCGM exporter)
2. If health checks fail (e.g., node NotReady, GPU offline):
   - Run a targeted Ansible play to:
     - Restart K8s services
     - Restart GPU services
   - Or open an incident (GitHub issue, ticket)
3. Notify channel with:
   - What failed
   - What was attempted
   - Links to relevant dashboards / logs

---

## 4. Implementation Phases

### Phase 0 – Local Dev (Current state)

- Terraform, Ansible, and Docker dev image are all working locally.
- No n8n automation yet; everything is manual CLI.

### Phase 1 – Manual n8n Actions

- Add simple n8n workflows that:
  - Run `terraform plan` / `terraform apply` on-demand.
  - Run `ansible-playbook ...` on-demand.
- No GitHub integration or approvals yet; this is for convenience and testing.

### Phase 2 – GitHub Integration + Approvals

- Add GitHub webhook into n8n.
- Implement a “plan → approve → apply” pattern for a single environment (e.g., `dev`).
- Add Slack/Discord/email notifications for:
  - Plan results
  - Apply results
  - Ansible runs

### Phase 3 – Full Self-Service and Health Checks

- Implement a “create dev cluster” workflow with basic input validation.
- Add health-check workflows and optional auto-remediation.
- Ensure all workflows leave an audit trail (issues, comments, logs).

---

## 5. Expected Interfaces (Commands n8n Will Call)

For now, n8n will primarily call these **local commands** (examples):

```bash
# Terraform dev (AWS example)
terraform -chdir=terraform/envs/dev/aws init
terraform -chdir=terraform/envs/dev/aws plan -var-file="terraform.tfvars"
terraform -chdir=terraform/envs/dev/aws apply -var-file="terraform.tfvars" -auto-approve

# Ansible configuration
ansible-playbook ansible/playbooks/bootstrap.yml
ansible-playbook ansible/playbooks/k8s-cluster.yml
ansible-playbook ansible/playbooks/gpu-nodes.yml
