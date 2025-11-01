variable "aws_region" {
  type        = string
  description = "AWS region to deploy EKS in"
  default     = "us-west-2"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use"
  default     = "default"
}

variable "eks_role_arn" {
  type        = string
  description = "IAM role ARN for EKS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for EKS VPC config"
}

variable "launch_template_id" {
  type        = string
  description = "Launch template for GPU nodes"
  default     = ""
}
