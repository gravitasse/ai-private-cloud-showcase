terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# local-only inventory so we can test Ansible on macOS
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventories/generated/hosts.ini"
  content  = <<-EOT
[k8s_control]
127.0.0.1 ansible_connection=local ansible_become=false

[k8s_workers]

[k8s_nvidia]

[k8s_intel]
EOT
}
