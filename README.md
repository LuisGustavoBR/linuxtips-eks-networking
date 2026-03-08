# LinuxTips EKS Networking Infrastructure

This Terraform project provisions a complete and highly available network infrastructure for Amazon EKS (Elastic Kubernetes Service) clusters on AWS.

## Network Architecture

### Overview
The infrastructure implements a robust network architecture with **high availability** and **security**, following AWS best practices for EKS.

### Main Components

#### VPC (Virtual Private Cloud)
- **Primary CIDR**: `10.0.0.0/16`
- **Additional CIDR**: `100.64.0.0/16` (reserved for EKS pods)
- **DNS**: Enabled for hostnames and support
- **Region**: `us-east-1`

#### Public Subnets (3 AZs)
- **Availability**: `us-east-1a`, `us-east-1b`, `us-east-1c`
- **CIDR Blocks**:
  - `10.0.48.0/24` (AZ 1a)
  - `10.0.49.0/24` (AZ 1b)
  - `10.0.50.0/24` (AZ 1c)
- **Role**: Host Load Balancers, NAT Gateways, and public resources

#### Private Subnets (4 subnets)
- **Applications**: `10.0.0.0/20`, `10.0.16.0/20`, `10.0.32.0/20`
- **EKS Pods**: `100.64.0.0/18` (AZ 1a)
- **Role**: Host EKS nodes, applications, and internal services

#### Database Subnets (Optional)
- **Isolation**: Restrictive Network ACLs
- **Role**: RDS, ElastiCache, DocumentDB

### Connectivity and Routing

#### Internet Gateway
- **Role**: Direct internet access for public subnets
- **Routing**: `0.0.0.0/0` → IGW

#### NAT Gateways (3 per AZ)
- **Elastic IPs**: One per AZ for high availability
- **Role**: Allow outbound internet access from private subnets
- **Routing**: `0.0.0.0/0` → NAT Gateway of the same AZ

#### Route Tables
- **Public**: Shared by all public subnets
- **Private**: One per private subnet (3 total)
- **Associations**: Direct subnet ↔ route table binding

### Security

#### Network ACLs
- **Database Subnets**: Restrictive egress/ingress rules
- **Default**: Allows all traffic (can be customized)

#### Isolation
- **Private Subnets**: No direct internet access
- **Public Subnets**: Controlled public access
- **Database Layer**: Additional isolation layer

## Architecture Diagram

![EKS Networking](https://github.com/LuisGustavoBR/linuxtips-eks/blob/main/01%20-%20EKS%20Fundamentals%20and%20Networking%20Foundation/images/eks-networking.png)

## How to Use

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured
- AWS profile with appropriate permissions

### Deploy
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan changes
terraform plan --var-file=environment/prod/terraform.tfvars

# Apply infrastructure
terraform apply --var-file=environment/prod/terraform.tfvars
```

### Destroy
```bash
terraform destroy --var-file=environment/prod/terraform.tfvars
```

## Project Structure

```
linuxtips-eks-networking/
├── backend.tf              # S3 backend configuration
├── providers.tf            # AWS providers
├── vpc.tf                  # Main VPC and additional CIDRs
├── internet_gateway.tf     # Internet Gateway
├── public_subnets.tf       # Public subnets + Route Table
├── private_subnets.tf      # Private subnets + NAT Gateways
├── database_subnets.tf     # Database subnets (optional)
├── variables.tf            # Variable declarations
├── outputs.tf              # Module outputs
├── environment/
│   └── prod/
│       ├── terraform.tfvars    # Production variables
│       └── backend.tfvars      # Backend configuration
└── README.md               # This documentation
```

## Customization

### Add Database Subnets
Edit `terraform.tfvars`:
```hcl
database_subnets = [
  {
    name              = "linuxtips-db-1a"
    cidr              = "10.0.64.0/24"
    availability_zone = "us-east-1a"
  }
]
```

### Modify CIDRs
Adjust the variables in `terraform.tfvars` as needed.

## Tags and Naming
- **Standard**: `{project_name}-{resource}-{az}`
- **Example**: `linuxtips-vpc-public-1a`

## Security Considerations
- Subnet isolation by function
- NAT Gateways for controlled outbound
- Network ACLs for database layer
- Dedicated Elastic IPs per AZ
- Segregated Route Tables

## Scalability
- **Multi-AZ**: 3 Availability Zones
- **Horizontal**: Easy addition of subnets
- **Vertical**: CIDR blocks planned for growth

**Note**: This infrastructure was designed following AWS best practices for EKS and can be integrated with other Terraform modules to create complete clusters.

## Usage

Each module folder contains its own README with objectives, configuration files, and step-by-step exercises.  
You can clone the repository and follow along:

```bash
git clone https://github.com/LuisGustavoBR/linuxtips-eks-networking.git
```

## How to Contribute

Contributions are welcome!  
If you find issues or have improvements, feel free to open a pull request.  
Please maintain consistent formatting and clear explanations in your submissions.

## Disclaimer

This repository is for educational purposes only.  
While it follows best practices, it may not reflect production-grade configurations.  
Always validate your setup and consult the official EKS documentation for deployment-critical environments.

## Credits

Original training by **LinuxTips**  
Hands-on notes and exercises compiled by **Luis Gustavo Bordon**