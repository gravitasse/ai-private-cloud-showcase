variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "zone_id" {
  type        = string
  description = "Hosted zone ID for your domain"
}

variable "domain_name" {
  type        = string
  description = "Base domain, e.g. example.com"
}

variable "primary_domain" {
  type        = string
  description = "ALB/NLB/GA endpoint for primary (AWS EKS)"
}

variable "primary_zone_id" {
  type        = string
  description = "Zone ID of the primary alias target"
}

variable "secondary_domain" {
  type        = string
  description = "Endpoint for secondary (GKE exposed via HTTPS LB)"
}

variable "secondary_zone_id" {
  type        = string
  description = "Zone ID of the secondary alias target"
}
