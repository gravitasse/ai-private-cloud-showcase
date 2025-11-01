provider "openstack" {
  auth_url    = var.os_auth_url
  tenant_name = var.os_tenant
  user_name   = var.os_user
  password    = var.os_pass
  region      = "RegionOne"
}

variable "control_count" { type = number }
variable "nvidia_gpu_count" { type = number }
variable "intel_gpu_count" { type = number }

resource "openstack_compute_instance_v2" "ctrl" {
  count       = var.control_count
  name        = "k8s-ctrl-${count.index}"
  image_name  = "ubuntu-24.04"
  flavor_name = "c4r16"
  key_pair    = "tyson"
  network { name = "k8s-net" }
}

resource "openstack_compute_instance_v2" "nvidia" {
  count       = var.nvidia_gpu_count
  name        = "k8s-nvidia-${count.index}"
  image_name  = "ubuntu-24.04"
  flavor_name = "gpu.a100.xlarge"
  key_pair    = "tyson"
  network { name = "k8s-net" }
}

resource "openstack_compute_instance_v2" "intel" {
  count       = var.intel_gpu_count
  name        = "k8s-intel-${count.index}"
  image_name  = "ubuntu-24.04"
  flavor_name = "gpu.intel.xlarge"
  key_pair    = "tyson"
  network { name = "k8s-net" }
}

output "control_ips" {
  value = [for s in openstack_compute_instance_v2.ctrl : s.access_ip_v4]
}

output "nvidia_ips" {
  value = [for s in openstack_compute_instance_v2.nvidia : s.access_ip_v4]
}

output "intel_ips" {
  value = [for s in openstack_compute_instance_v2.intel : s.access_ip_v4]
}
