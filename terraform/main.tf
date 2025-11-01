terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "control_count" {
  type    = number
  default = 1
}

variable "nvidia_gpu_count" {
  type    = number
  default = 1
}

variable "intel_gpu_count" {
  type    = number
  default = 1
}

module "openstack" {
  source           = "./openstack"
  control_count    = var.control_count
  nvidia_gpu_count = var.nvidia_gpu_count
  intel_gpu_count  = var.intel_gpu_count
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventories/generated/hosts.ini"
  content  = templatefile("${path.module}/templates/hosts.ini.tftpl", {
    control_ips = module.openstack.control_ips
    nvidia_ips  = module.openstack.nvidia_ips
    intel_ips   = module.openstack.intel_ips
  })
}
