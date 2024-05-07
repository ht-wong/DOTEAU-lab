# ############################# Task 4 ##################################
# 构建三个SG，分别为 elb/app/sg，开放端口为 80/8080,22/3306
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group.html
resource "aws_security_group" "sg" {
  for_each    = var.sg_basic
  name        = join("/", [local.resource_prefix, each.key])
  description = "${each.key} SG"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = join("/", [local.resource_prefix, each.key])
  }

  dynamic "ingress" {
    for_each = var.sg_basic[each.key].ingress
    iterator = ingress
    content {
      cidr_blocks = [ingress.value[0]]
      protocol    = ingress.value[1]
      from_port   = ingress.value[2]
      to_port     = ingress.value[3]
    }
  }
  dynamic "egress" {
    for_each = var.sg_basic[each.key].egress
    iterator = egress
    content {
      cidr_blocks = [egress.value[0]]
      protocol    = egress.value[1]
      from_port   = egress.value[2]
      to_port     = egress.value[3]
    }
  }
}

# SG Chain Defined
resource "aws_vpc_security_group_ingress_rule" "chains" {
  count                        = length(var.sg_chain)
  referenced_security_group_id = aws_security_group.sg[var.sg_chain[count.index][0]].id
  security_group_id            = aws_security_group.sg[var.sg_chain[count.index][1]].id
  ip_protocol                  = var.sg_chain[count.index][2]
  from_port                    = var.sg_chain[count.index][3]
  to_port                      = var.sg_chain[count.index][4]
}

# ############################# Task 5 ##################################
# DB Instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# Generate Key
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
  subnet_id                   = aws_subnet.bastion.id
  vpc_security_group_ids      = [aws_security_group.sg["bastion"].id, ]
  associate_public_ip_address = true
  key_name                    = var.ssh_key
  tags = {
    Name = join("/", [local.resource_prefix, "bastion"])
  }
}
# DB Instance
resource "aws_instance" "db" {
  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.db[0].id
  vpc_security_group_ids = [aws_security_group.sg["db"].id, ]
  key_name               = var.ssh_key
  tags = {
    Name = join("/", [local.resource_prefix, "db"])
  }
}
# app Instance
resource "aws_instance" "app" {
  count                  = var.n_app
  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app[count.index].id
  vpc_security_group_ids = [aws_security_group.sg["app"].id, ]
  key_name               = var.ssh_key
  tags = {
    Name = join("/", [local.resource_prefix, "app"])
  }
}

# ############################# Task 5 ##################################
# Config DB Instance
resource "terraform_data" "config_db" {
  # 需要能出到公网才行
  depends_on = [aws_nat_gateway.main]
  connection {
    type         = "ssh"
    user         = "ec2-user"
    private_key  = file("./static/${var.ssh_key}.pem")
    host         = aws_instance.db.private_ip
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ec2-user"
  }
  provisioner "file" {
    source      = "${path.module}/template/db.py"
    destination = "/home/ec2-user/db.py"
  }
  provisioner "remote-exec" {
    script = "${path.module}/template/db.sh"
  }
  # triggers_replace = timestamp()
  triggers_replace = [
    data.local_file.db.content,
    # timestamp()
  ]
}
# Config APP Instance
resource "terraform_data" "config_app" {
  # 需要能出到公网才行
  count      = var.n_app
  depends_on = [aws_nat_gateway.main]
  connection {
    type         = "ssh"
    user         = "ec2-user"
    private_key  = file("${path.module}/static/${var.ssh_key}.pem")
    host         = aws_instance.app[count.index].private_ip
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ec2-user"
  }
  provisioner "file" {
    source      = "${path.module}/template/app.py"
    destination = "/home/ec2-user/app.py"
  }
  provisioner "remote-exec" {
    script = "${path.module}/template/app.sh"
  }
  # triggers_replace = timestamp()
  triggers_replace = [
    data.local_file.app.content,
    # timestamp()
  ]
}

