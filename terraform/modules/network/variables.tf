variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for public subnets"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc.)"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster using this VPC"
}
