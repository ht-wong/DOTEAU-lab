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
