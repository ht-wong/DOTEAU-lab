# ############################# Task 1 ##################################
/*
variable "region" {
  type        = 
  description = "AWS Resource Region"
  default     = 
}
variable "app" {
  type        = 
  description = "Application Name"
}
variable "env" {
  type        = 
  description = "Application Environment"
  # 必须是下面的值之一，prod/stage/test/dev
  validation {
    condition = 
    error_message = "must in prod/stage/test/dev"
  }
}
variable "vpc_cidr" {
  type        = 
  description = "VPC Cidr Block"
  # 需要判断是否为cidr段
  validation {
    condition     = 
    error_message = "Must Input a CIDR Block"
  }
}
*/
# ############################# Task 2 ##################################
/*
# 用作堡垒机所用cidr
variable "bastion_cidr" {
  type        = string
  description = "bastion subnet cidr block"
  validation {
    condition     = can(cidrnetmask("${var.bastion_cidr}"))
    error_message = "Must Input a CIDR Block"
  }
}
*/
# ############################# Task 3 ##################################
# 三个subnet的cidr block 列表
/*
variable "public_cidr" {
  type        = 
  description = "public subnet cidr block"
  validation {
    condition     = 
    error_message = "Need every item is CIDR Block"
  }
}
variable "app_cidr" {
  type        = 
  description = "app subnet cidr block"
  validation {
    condition     = 
    error_message = "Need every item is CIDR Block"
  }
}
variable "db_cidr" {
  type        = 
  description = "db subnet cidr block"
  validation {
    condition     = 
    error_message = "Need every item is CIDR Block"
  }
}
*/
# ############################# Task 4 ##################################
/*
variable "sg_basic" {
  # 设定type以规范用户输入，用户需要输入的规则在default中已示范
  type = 
  description = "sg rules"
  default = {
    "elb" = {
      "ingress" : [
        ["0.0.0.0/0", "tcp", "80", "80"],
        ["0.0.0.0/0", "tcp", "443", "443"],
      ],
      "egress" : [
        ["0.0.0.0/0", "ALL", "0", "0"]
      ],
    },
    "app" = {
      "ingress" : [],
      "egress" : [
        ["0.0.0.0/0", "ALL", "0", "0"]
      ],
    },
    "db" = {
      "ingress" : [],
      "egress" : [
        ["0.0.0.0/0", "ALL", "0", "0"]
      ],
    },
    "bastion" = {
      "ingress" : [
        ["0.0.0.0/0", "tcp", "22", "22"],
      ],
      "egress" : [
        ["0.0.0.0/0", "ALL", "0", "0"]
      ],
    }
  }
}

variable "sg_chain" {
  # 设定type以规范用户输入，用户需要输入的规则在default中已示范
  type        = 
  description = "define sg chain "
  default = [
    ["elb", "app", "tcp", "8080", "8080"],
    ["app", "db", "tcp", "3306", "3306"],
    ["bastion", "app", "tcp", "22", "22"],
  ]
}
*/
# ############################# Task 5 ##################################
/*
variable "ssh_key" {
  type        = string
  description = "ssh key name"
  default     = "terraform"
}
variable "n_app" {
  type        = number
  description = "App instance Quantity"
  default     = 3
}
*/
