# ############################# Task 1 ##################################
/*
# 构建一个vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  # 补充 cidr_block 
  cidr_block = 
  tags = {
    # 补充 NAME: lab02/dev/main, 需要使用 local 中的 resource_prefix 
    Name =  
  }
}
*/

# ############################# Task 2 ##################################
/*
# Bastion Subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "bastion" {
  vpc_id     = 
  # cidr 来自 var.bastion_cidr
  cidr_block = 
  # 需位于第一个 az
  availability_zone = 
  # 补充 NAME: lab02/dev/bastion, 需要使用 local 中的 resource_prefix 
  tags = {
    Name = 
  }
}

# IGW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  # 关联
  vpc_id = 
  # 补充 NAME: lab02/dev/igw, 需要使用 local 中的 resource_prefix 
  tags = {
    Name = 
  }
}

# Public RT
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = 
  }
  tags = {
  # 补充 NAME: lab02/dev/bastion, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}
# Attach Public RT to Bastion
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "bastion" {
  subnet_id      = 
  route_table_id = 
}
*/
# ############################# Task 3 ##################################
/*
# Public Subnets
resource "aws_subnet" "public" {
  count                   = 
  vpc_id                  = 
  # cidr 来自 var.public_cidr
  cidr_block              = 
  map_public_ip_on_launch = true
  # 每个子网都位于不同的AZ中
  availability_zone       = 
  tags = {
  # 补充 NAME: lab02/dev/public/01, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}

# Attach Public RT to Public Subnets
resource "aws_route_table_association" "public" {}

# EIP for NAT GW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
  # 补充 NAME: lab02/dev/nat, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}

# Nat GW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "main" {
  depends_on    = [aws_internet_gateway.main]
  # 使用 aws_eip.nat
  allocation_id = 
  # 位于 bastion subnet
  subnet_id     = 
  tags = {
  # 补充 NAME: lab02/dev/nat, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}

# APP Subnets
resource "aws_subnet" "app" {
  count             = 
  vpc_id            = 
  cidr_block        = 
  availability_zone = 
  tags = {
  # 补充 NAME: lab02/dev/app/01, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}
# Private RT
resource "aws_route_table" "private" {
  vpc_id = 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = 
  }
  tags = {
  # 补充 NAME: lab02/dev/private, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}
# Attach Private RT to APP Subnets
resource "aws_route_table_association" "app" {}

# DB Subnets
resource "aws_subnet" "db" {
  count             = 
  vpc_id            = 
  cidr_block        = 
  availability_zone = 
  tags = {
  # 补充 NAME: lab02/dev/db/01, 需要使用 local 中的 resource_prefix 
    Name = 
  }
}

# Attach Private RT to Private Subnets
resource "aws_route_table_association" "db" {}
*/

