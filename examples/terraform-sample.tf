terraform {
  required_providers {
    local = { source = "hashicorp/local" }
  }
}

# Example output file (used by Ansible)
resource "local_file" "inventory" {
  filename = "../ansible/inventory/hosts.ini"
  content  = <<EOT
[k8s_control]
10.0.0.10 ansible_user=ubuntu

[k8s_workers]
10.0.0.11 ansible_user=ubuntu
10.0.0.12 ansible_user=ubuntu
EOT
}
