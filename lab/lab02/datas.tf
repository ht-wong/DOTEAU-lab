data "aws_availability_zones" "available" {
  state = "available"
}
# ############################# Task 5 ##################################
/*
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
# https://ap-northeast-1.console.aws.amazon.com/ec2/home?region=ap-northeast-1#Images:visibility=public-images;ownerAlias=amazon;architecture=x86_64;virtualization=hvm;imageName=:amzn2-ami-kernel-5.10-hvm-2.0.20240412.0-x86_64-gp2;v=3;$case=tags:false%5C,client:false;$regex=tags:false%5C,client:false
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
data "local_file" "db" {
  filename = "${path.module}/template/db.py"
}

data "local_file" "app" {
  filename = "${path.module}/template/app.py"
}
*/
# ############################# Task 6 ##################################
/*
# 检测 ELB DNS
data "http" "elb_hc" {}
*/