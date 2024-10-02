locals {
  public_subnet_configs = flatten([
    for vpc in var.vpc_config : [
      for index, cidr in vpc.public_subnet_cidr : {
        cidr        = cidr
        az          = data.aws_availability_zones.az.names[index]
        vpc_cidr    = vpc.vpc_cidr
        subnet_key  = vpc.public_subnet_names[index]
        vpcname     = vpc.vpcname
      }
    ]
  ])

  private_subnet_configs = flatten([
    for vpc in var.vpc_config : [
      for index, cidr in vpc.private_subnet_cidr : {
        cidr        = cidr
        az          = data.aws_availability_zones.az.names[index]
        vpc_cidr    = vpc.vpc_cidr
        subnet_key  = vpc.private_subnet_names[index]
        vpcname     = vpc.vpcname
      }
    ]
  ])

  public_route_table_associations = flatten([
    for vpc in var.vpc_config : [
      for idx, subnet_cidr in vpc.public_subnet_cidr : {
        subnet_key      = "${vpc.vpcname}-${vpc.public_routetablename}-association-${idx}"
        subnet_id       = aws_subnet.public_subnets[vpc.public_subnet_names[idx]].id
        route_table_id  = aws_route_table.public_routetable[vpc.public_routetablename].id
      }
    ]
  ])

  private_route_table_associations = flatten([
    for vpc in var.vpc_config : [
      for idx, subnet_cidr in vpc.private_subnet_cidr : {
        subnet_key      = "${vpc.vpcname}-${vpc.private_routetablename}-association-${idx}"
        subnet_id       = aws_subnet.private_subnets[vpc.private_subnet_names[idx]].id
        route_table_id  = aws_route_table.private_routetable[vpc.private_routetablename].id
      }
    ]
  ])
}

# Create VPCs
resource "aws_vpc" "vpc" {
  for_each = { for vpc in var.vpc_config : vpc.vpcname => {
    vpc_cidr = vpc.vpc_cidr
  }}

  cidr_block = each.value.vpc_cidr

  tags = {
    Name = each.key
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each = { for subnet in flatten(local.public_subnet_configs) : subnet.subnet_key => subnet }

  vpc_id            = aws_vpc.vpc[each.value.vpcname].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each = { for subnet in flatten(local.private_subnet_configs) : subnet.subnet_key => subnet }

  vpc_id            = aws_vpc.vpc[each.value.vpcname].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  for_each = { for vpc in var.vpc_config : vpc.igwname => vpc }

  vpc_id = aws_vpc.vpc[each.value.vpcname].id
  tags = {
    Name = "Internet Gateway-${each.value.igwname}"
  }
}

# Create Public Route Tables
resource "aws_route_table" "public_routetable" {
  for_each = { for vpc in var.vpc_config : vpc.public_routetablename => vpc }

  vpc_id = aws_vpc.vpc[each.value.vpcname].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.value.igwname].id
  }

  tags = {
    Name = "PublicRouteTable-${each.key}"
  }
}

# Create Private Route Tables (No routes to IGW)
resource "aws_route_table" "private_routetable" {
  for_each = { for vpc in var.vpc_config : vpc.private_routetablename => vpc }

  vpc_id = aws_vpc.vpc[each.value.vpcname].id

  tags = {
    Name = "PrivateRouteTable-${each.key}"
  }
}

# Associate Public Route Tables with Public Subnets
resource "aws_route_table_association" "public_routetable_association" {
  for_each = { for association in local.public_route_table_associations : association.subnet_key => association }

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}

# Associate Private Route Tables with Private Subnets
resource "aws_route_table_association" "private_routetable_association" {
  for_each = { for association in local.private_route_table_associations : association.subnet_key => association }

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}
