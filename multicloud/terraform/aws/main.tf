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

resource "aws_eks_cluster" "primary" {
  name     = "ai-primary-eks"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

# ASG for GPU worker nodes (NVIDIA)
# In a real build you'd use eks_node_group, but this shows intent
resource "aws_autoscaling_group" "gpu_nodes" {
  name             = "ai-primary-gpu"
  min_size         = 1
  max_size         = 4
  desired_capacity = 2

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  # your target group / subnets go here
}

output "primary_api_endpoint" {
  value = aws_eks_cluster.primary.endpoint
}
