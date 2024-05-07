# ############################# Task 4 ##################################
# 构建三个SG，分别为 elb/app/sg，开放端口为 80/8080,22/3306
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group.html
/*
resource "aws_security_group" "sg" {
  for_each    = var.sg_basic
  # 声明name 示范：app/env/elb
  name        = 
  # Like "elb SG"
  description = 
  vpc_id      = aws_vpc.main.id
  tags = {
  # 声明 Name tag 示范：app/env/elb
    Name = 
  }
  
  dynamic "ingress" {
    # 声明 Ingress 条目
    for_each = 
    iterator = ingress
    content {
      cidr_blocks = 
      protocol    = 
      from_port   = 
      to_port     = 
    }
  }
  dynamic "egress" {
    # 声明 Egress 条目
    for_each = 
    iterator = egress
    content {
      cidr_blocks = 
      protocol    = 
      from_port   = 
      to_port     = 
    }
  }
}

# SG Chain Defined
resource "aws_vpc_security_group_ingress_rule" "chains" {
  count                        = length(var.sg_chain)
  referenced_security_group_id = 
  security_group_id            = 
  ip_protocol                  = 
  from_port                    = 
  to_port                      = 
}
*/

# ############################# Task 5 ##################################
/*
# DB Instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# 构建一个Key Pair 用作之后ssh使用
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "aws_key_pair" "key" {
  key_name   = var.ssh_key
  public_key = tls_private_key.key.public_key_openssh
}
resource "local_file" "key_file" {
  content         = tls_private_key.key.private_key_pem
  filename        = "./static/${var.ssh_key}.pem"
  file_permission = 0400
}

# Bastion Instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = "t2.micro"
  # 需要位于 Bastion Subnet
  subnet_id                   = 
  # 使用 bastion sg
  vpc_security_group_ids      = 
  associate_public_ip_address = true
  key_name                    = var.ssh_key
  tags = {
  # 声明 NAME = lab02/dev/bastion
    Name = 
  }
}
# DB Instance
resource "aws_instance" "db" {
  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t2.micro"
  # 位于第一个 DB subnets
  subnet_id              = 
  # 使用 db sg
  vpc_security_group_ids = 
  key_name               = var.ssh_key
  tags = {
  # 声明 NAME = lab02/dev/db
    Name = 
  }
}
# app Instance
resource "aws_instance" "app" {
  count                  = var.n_app
  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t2.micro"
  # 实例应该分散到多个 APP Subnet
  subnet_id              = 
  # 使用 APP SG
  vpc_security_group_ids = 
  key_name               = var.ssh_key
  tags = {
  # # 声明 NAME = lab02/dev/app
    Name = 
  }
}
*/
# Configuration
/*
# Config DB Instance
resource "terraform_data" "config_db" {
  depends_on = [aws_nat_gateway.main]
  
  # 需要通过堡垒机来进行位于私有子网的实例， 连接用户为ec2-user
  connection {}
  provisioner "file" {
    source      = "${path.module}/template/db.py"
    destination = "/home/ec2-user/db.py"
  }
  provisioner "remote-exec" {
    script = "${path.module}/template/db.sh"
  }
  
  # 当/home/ec2-user/db.py 内容变化的时候，需要重新构建此资源
  triggers_replace = [
  
  ]
}
# Config APP Instance
resource "terraform_data" "config_app" {
  # 模仿 Config DB Config，配置 APP instance
  # 相关文件 位于 template/db.py | /template/db.sh
  count      = var.n_app
  depends_on = [aws_nat_gateway.main]
  connection {}
  provisioner "file" {}
  provisioner "remote-exec" {}
  triggers_replace = [
    
  ]
}
*/

