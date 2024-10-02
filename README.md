# VPC Terraform Module

This repository provides a Terraform module for creating AWS VPCs with separate public and private subnets. It includes Internet Gateways, route tables, and their associations with the respective subnets.

## Features

- Creates multiple VPCs with specified CIDR blocks.
- Defines both public and private subnets for each VPC.
- Configures Internet Gateways (IGW) for public subnets.
- Associates public subnets with public route tables and private subnets with private route tables.

## Prerequisites

- Terraform 0.12+ installed.
- AWS credentials configured (via environment variables, AWS CLI, or AWS IAM roles).

## Usage

1. Define your `vpc_config` in your Terraform code. Here's an example:

    ```hcl
    module "vpc" {
      source = "./modules/vpc"

      vpc_config = [
        {
          vpc_cidr            = "10.0.0.0/16"
          public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
          private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
          public_subnet_names = ["Public-Subnet1-VPC1", "Public-Subnet2-VPC1"]
          private_subnet_names = ["Private-Subnet1-VPC1", "Private-Subnet2-VPC1"]
          igwname             = "IGW1"
          public_routetablename  = "PublicRouteTable1"
          private_routetablename = "PrivateRouteTable1"
          vpcname             = "vpc1"
        },
        {
          vpc_cidr            = "10.1.0.0/16"
          public_subnet_cidr  = ["10.1.1.0/24", "10.1.2.0/24"]
          private_subnet_cidr = ["10.1.3.0/24", "10.1.4.0/24"]
          public_subnet_names = ["Public-Subnet1-VPC2", "Public-Subnet2-VPC2"]
          private_subnet_names = ["Private-Subnet1-VPC2", "Private-Subnet2-VPC2"]
          igwname             = "IGW2"
          public_routetablename  = "PublicRouteTable2"
          private_routetablename = "PrivateRouteTable2"
          vpcname             = "vpc2"
        }
      ]
    }
    ```

2. Run Terraform commands to deploy:

    ```bash
    terraform init
    terraform apply
    ```

## Outputs

- `public_subnet_configs`: List of configurations for all public subnets.
- `private_subnet_configs`: List of configurations for all private subnets.
- `public_route_table_associations`: Route table associations for public subnets.
- `private_route_table_associations`: Route table associations for private subnets.

## Resources Created

- AWS VPCs
- Public Subnets
- Private Subnets
- Internet Gateways
- Public Route Tables with routes to the Internet Gateway
- Private Route Tables (without routes to the Internet)
- Route Table associations for public and private subnets.

## License

This module is licensed under the MIT License.
