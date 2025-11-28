terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Start with local backend so we don't touch any existing remote state yet
  backend "local" {}
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source              = "../../../modules/network"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  environment         = var.environment
  cluster_name        = var.cluster_name
}

module "k8s_cluster" {
  source               = "../../../modules/k8s-cluster"
  cluster_name         = var.cluster_name
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.public_subnet_ids
  master_count         = var.master_count
  worker_count         = var.worker_count
  instance_type_master = var.instance_type_master
  instance_type_worker = var.instance_type_worker
  ssh_key_name         = var.ssh_key_name
  master_ami_id        = var.master_ami_id
  worker_ami_id        = var.worker_ami_id
}

output "ansible_inventory" {
  value       = module.k8s_cluster.ansible_inventory
  description = "Ansible inventory data for this cluster"
}
