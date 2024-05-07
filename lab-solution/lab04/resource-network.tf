# ############################# Task 1 ##################################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = join("/", [local.resource_prefix, "main"]),
  }
}

# 以下是一个 subnet 示范
# Reference：https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# resource "aws_subnet" "demo" {
#   vpc_id                  = [VPC_ID]
#   cidr_block              = [CIDR]
#   availability_zone       = [AZ_NAME]
#   map_public_ip_on_launch = [true / false]
# }

# ############################# Task 2 ##################################
# Subnet Bastion
# 要求每一个subnet位于不同的AZ，想一下，如果有三个AZ，但是要有四个子网，需要 a,b,c,a这样分配。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "bastion" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.bastion_cidr
  # 位于第一个az
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = join("/", [local.resource_prefix, "bastion"]),
  }
}

# IGW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = join("/", [local.resource_prefix, "igw"]),
  }
}

# Public RT
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = join("/", [local.resource_prefix, "public"]),
  }
}

# ############################# Task 3 ##################################
# Attach Public RT to Bastion
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "bastion" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.public.id
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("/", [local.resource_prefix, "public", count.index])
  }
}

# Attach Public RT to Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ############################# Task 4 ##################################
# EIP for NAT GW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = join("/", [local.resource_prefix, "nat"])
  }
}

# Nat GW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "main" {
  depends_on    = [aws_internet_gateway.main]
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.bastion.id
  tags = {
    Name = join("/", [local.resource_prefix, "nat"])
  }
}

# ############################# Task 5 ##################################
# APP Subnets
resource "aws_subnet" "app" {
  count             = length(var.app_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("/", [local.resource_prefix, "app", count.index])
  }
}
# Private RT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = join("/", [local.resource_prefix, "private"]),
  }
}
# Attach Private RT to APP Subnets
resource "aws_route_table_association" "app" {
  count          = length(var.app_cidr)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.private.id
}

# DB Subnets
resource "aws_subnet" "db" {
  count             = length(var.db_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("/", [local.resource_prefix, "db", count.index])
  }
}

# Attach Private RT to Private Subnets
resource "aws_route_table_association" "db" {
  count          = length(var.db_cidr)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.private.id
}


