variable "os_auth_url" {
  type        = string
  description = "OpenStack auth URL, e.g. https://YOUR-OPENSTACK:5000/v3"
}

variable "os_tenant" {
  type        = string
  description = "OpenStack project/tenant name"
}

variable "os_user" {
  type        = string
  description = "OpenStack user"
}

variable "os_pass" {
  type        = string
  description = "OpenStack password"
}
