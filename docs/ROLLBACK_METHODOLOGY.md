# AI Private Cloud - Rollback Methodology

This repository has evolved from a basic K8s cluster skeleton into a hardened, highly available, multi-cloud enterprise architecture. If you need to revert to the initial "local mock" testing version for debugging or presentation purposes, follow these steps.

## 1. Git Rollback
To completely revert the codebase to the state before the advanced resilience (NLB, Route 53) and modular storage architectures were added, use Git.

### View History
Find the commit hash of the initial state:
```bash
git log --oneline
```

### Temporary Revert (Testing)
If you only want to run the old code temporarily without destroying the history:
```bash
git checkout <commit-hash>
```
When finished, `git checkout main` to return.

### Hard Reset (Destructive)
If you want to permanently delete all new work and reset the `main` branch to the old state:
```bash
git reset --hard <commit-hash>
git push origin main --force
```

## 2. Terraform State Management
> [!WARNING]
> **CRITICAL: Terraform State Drift**
> If you have already run `terraform apply` on the new hardened modules (like the Network Load Balancer or Route 53), performing a Git rollback will result in a disconnect between your code and your actual cloud infrastructure.

If infrastructure is actively deployed:
1. **Destroy first:** Before checking out an old Git commit, run `terraform destroy` to clean up the advanced resources (NLBs, NAT Gateways).
2. **Rollback Git:** Run your `git checkout` or `git reset`.
3. **Re-apply:** Run `terraform apply` on the old code to recreate the simple infrastructure.

If you skip the destroy step, the advanced resources will be "orphaned" in AWS and continue costing money, as the older Terraform state will not know they exist.

## 3. The Docker Compose Alternative
If you are rolling back because the Kubernetes modules have become too heavy for a specific use case, remember that the `vps-docker/` directory contains an "AI Cloud in a Box." This provides Ollama, Open WebUI, and n8n on a single node using simple `docker-compose up -d`.
