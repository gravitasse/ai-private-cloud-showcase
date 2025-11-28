variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}

variable "cluster_name" {
  type        = string
  description = "Name of this cluster"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "master_count" {
  type        = number
  description = "Number of control-plane nodes"
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes"
}

variable "instance_type_master" {
  type        = string
  description = "Instance type for masters"
}

variable "instance_type_worker" {
  type        = string
  description = "Instance type for workers"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the AWS key pair to use"
}

variable "master_ami_id" {
  type        = string
  description = "AMI ID for master nodes"
}

variable "worker_ami_id" {
  type        = string
  description = "AMI ID for worker nodes"
}
