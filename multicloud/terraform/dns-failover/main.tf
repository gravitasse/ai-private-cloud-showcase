terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_route53_health_check" "primary_eks" {
  fqdn              = var.primary_domain
  port              = 443
  type              = "HTTPS"
  request_interval  = 30
  failure_threshold = 3
}

resource "aws_route53_health_check" "secondary_gke" {
  fqdn              = var.secondary_domain
  port              = 443
  type              = "HTTPS"
  request_interval  = 30
  failure_threshold = 3
}

resource "aws_route53_record" "ai_service_primary" {
  zone_id = var.zone_id
  name    = "ai.${var.domain_name}"
  type    = "A"

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = var.primary_domain
    zone_id                = var.primary_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary_eks.id
}

resource "aws_route53_record" "ai_service_secondary" {
  zone_id = var.zone_id
  name    = "ai.${var.domain_name}"
  type    = "A"

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = var.secondary_domain
    zone_id                = var.secondary_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.secondary_gke.id
}
