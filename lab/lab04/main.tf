# ##################### META Config ##################### 
terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
  # ############################# TASK 2   ############################# 
  /*
  backend "s3" {
    region         = 
    bucket         = 
    dynamodb_table = 
    key            = 
  }
  */
}
provider "aws" {
  region = var.region
}
# ##################### Variable ##################### 
variable "region" {}
variable "app" {}
variable "instance_type" {
  type = string
  validation {
    condition = contains([
      "t2.micro",
      "t2.large",
      "t2.xlarge",
    ], var.instance_type)
    error_message = "must in t2.micro/t2.large/t2.xlarge"
  }
  default = "t2.micro"
}

# ##################### Local ##################### 
data "aws_ami" "amzn2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240412.0-x86_64-gp2"]
  }
}

# ##################### Local ##################### 
locals {
  prefix = join("/", [var.app, terraform.workspace])
}

# ##################### Resource ##################### 
resource "aws_instance" "worksapce_instance" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  tags = {
    Name = join("/", [local.prefix, "worksapceInstance"])
  }
}


