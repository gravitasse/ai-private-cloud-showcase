variable "cluster_name"           { type = string }
variable "environment"            { type = string }
variable "vpc_id"                 { type = string }
variable "subnet_ids"             { type = list(string) }
variable "aws_region"             { type = string }
variable "master_count"           { type = number }
variable "worker_count"           { type = number }
variable "instance_type_master"   { type = string }
variable "instance_type_worker"   { type = string }
variable "ssh_key_name"           { type = string }
variable "master_ami_id"          { type = string }
variable "worker_ami_id"          { type = string }

resource "aws_security_group" "k8s" {
  name        = "${var.environment}-${var.cluster_name}-k8s-sg"
  description = "Kubernetes nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tighten in real env
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.cluster_name}-k8s-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "k8s_master" {
  count         = var.master_count
  ami           = var.master_ami_id
  instance_type = var.instance_type_master
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [aws_security_group.k8s.id]

  tags = {
    Name        = "${var.environment}-${var.cluster_name}-master-${count.index}"
    Environment = var.environment
    Role        = "k8s_master"
  }
}

resource "aws_instance" "k8s_worker" {
  count         = var.worker_count
  ami           = var.worker_ami_id
  instance_type = var.instance_type_worker
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [aws_security_group.k8s.id]

  tags = {
    Name        = "${var.environment}-${var.cluster_name}-worker-${count.index}"
    Environment = var.environment
    Role        = "k8s_worker"
  }
}

output "k8s_masters" {
  value = {
    public_ips  = [for n in aws_instance.k8s_master : n.public_ip]
    private_ips = [for n in aws_instance.k8s_master : n.private_ip]
    hostnames   = [for n in aws_instance.k8s_master : n.tags["Name"]]
  }
}

output "k8s_workers" {
  value = {
    public_ips  = [for n in aws_instance.k8s_worker : n.public_ip]
    private_ips = [for n in aws_instance.k8s_worker : n.private_ip]
    hostnames   = [for n in aws_instance.k8s_worker : n.tags["Name"]]
  }
}

output "ansible_inventory" {
  value = {
    meta = {
      cluster_name = var.cluster_name
      environment  = var.environment
      cloud        = "aws"
      region       = var.aws_region
    }
    hosts = {
      k8s_masters = [for n in aws_instance.k8s_master : n.public_ip]
      k8s_workers = [for n in aws_instance.k8s_worker : n.private_ip]
    }
  }
}
