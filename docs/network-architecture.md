# Network Module - Production-Grade VPC Configuration

This module creates a production-ready VPC with public and private subnets across multiple availability zones, NAT gateways, Internet Gateway, and proper routing.

## Features

- ✅ Multi-AZ deployment (3 availability zones)
- ✅ Public subnets for load balancers and bastion hosts
- ✅ Private subnets for Kubernetes worker nodes
- ✅ NAT Gateway (HA or single mode)
- ✅ Internet Gateway for public subnet internet access
- ✅ Route tables (public → IGW, private → NAT)
- ✅ VPC Flow Logs for network monitoring
- ✅ DNS hostnames and resolution enabled

## Architecture

```
VPC (10.0.0.0/16)
├── Public Subnets (Internet-facing)
│   ├── 10.0.1.0/24 (AZ-a) → Internet Gateway
│   ├── 10.0.2.0/24 (AZ-b) → Internet Gateway
│   └── 10.0.3.0/24 (AZ-c) → Internet Gateway
│
├── Private Subnets (Internal)
│   ├── 10.0.11.0/24 (AZ-a) → NAT Gateway (AZ-a)
│   ├── 10.0.12.0/24 (AZ-b) → NAT Gateway (AZ-b or shared)
│   └── 10.0.13.0/24 (AZ-c) → NAT Gateway (AZ-c or shared)
│
├── Internet Gateway (IGW)
└── NAT Gateway(s) (1 or 3 depending on HA mode)
```

## Usage

### Basic Usage (Single NAT Gateway)

```hcl
module "network" {
  source = "../../modules/network"

  environment  = "dev"
  cluster_name = "ai-cluster"
  vpc_cidr     = "10.0.0.0/16"
  
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true  # Cost-effective for dev/test
}
```

### High Availability (NAT Gateway per AZ)

```hcl
module "network" {
  source = "../../modules/network"

  environment  = "prod"
  cluster_name = "ai-cluster"
  vpc_cidr     = "10.0.0.0/16"
  
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = false  # HA: one NAT per AZ
  
  enable_flow_logs = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `environment` | Environment name (dev/test/prod) | string | - | yes |
| `cluster_name` | Cluster name for resource tagging | string | - | yes |
| `vpc_cidr` | CIDR block for VPC | string | - | yes |
| `availability_zones` | List of AZs to use | list(string) | - | yes |
| `public_subnet_cidrs` | CIDR blocks for public subnets | list(string) | - | yes |
| `private_subnet_cidrs` | CIDR blocks for private subnets | list(string) | - | yes |
| `enable_nat_gateway` | Enable NAT Gateway for private subnets | bool | true | no |
| `single_nat_gateway` | Use single NAT (cost-effective) vs one per AZ (HA) | bool | false | no |
| `enable_flow_logs` | Enable VPC Flow Logs | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the VPC |
| `vpc_cidr` | CIDR block of the VPC |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `nat_gateway_ids` | List of NAT Gateway IDs |
| `internet_gateway_id` | ID of the Internet Gateway |

## Cost Considerations

### NAT Gateway Costs

- **Single NAT Gateway:** ~$32/month + data transfer
- **Multi-AZ NAT (3 AZs):** ~$96/month + data transfer
- **Recommendation:** Use single NAT for dev/test, multi-AZ for production

### VPC Flow Logs Costs

- **CloudWatch Logs:** ~$0.50/GB ingested
- **Recommendation:** Enable for production, disable for dev to save costs

## Security Best Practices

1. **Private Subnets for Workers:** All Kubernetes worker nodes should be in private subnets
2. **Public Subnets for LBs:** Only load balancers and bastion hosts in public subnets
3. **Network ACLs:** Consider adding NACLs for additional security layer
4. **Flow Logs:** Enable in production for security monitoring and troubleshooting

## Kubernetes Integration

This module automatically tags subnets for Kubernetes integration:

- **Public Subnets:** `kubernetes.io/role/elb = 1` (for external load balancers)
- **Private Subnets:** `kubernetes.io/role/internal-elb = 1` (for internal load balancers)
- **All Subnets:** `kubernetes.io/cluster/{cluster_name} = shared`
