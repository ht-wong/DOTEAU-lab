terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
}
provider "aws" {
  region = var.region
}

provider "random" {}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}
variable "region" {
  type        = string
  description = "AWS Resource Region"

  default = "ap-northeast-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"

  default = "t2.micro"
}
resource "random_pet" "server_name" {
  length = 2
  prefix = "demo-server"
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = random_pet.server_name.id
  }
}
