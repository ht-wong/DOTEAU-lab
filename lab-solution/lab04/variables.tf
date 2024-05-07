variable "region" {
  type        = string
  description = "AWS Resource Region"
  default     = "ap-northeast-1"
}
variable "app" {
  type        = string
  description = "Application Name"
}
variable "env" {
  type        = string
  description = "Application Environment"
  # 必须是下面的值之一，prod/stage/test/dev
  validation {
    condition = contains([
      "prod",
      "stage",
      "test",
      "dev"
    ], var.env)
    error_message = "must in prod/stage/test/dev"
  }
}
variable "revision" {
  type        = number
  description = "revision serial number"
}
variable "vpc_cidr" {
  type        = string
  description = "VPC Cidr Block"
  # 需要判断是否为cidr段
  validation {
    condition     = can(cidrnetmask("${var.vpc_cidr}"))
    error_message = "Must Input a CIDR Block"
  }
}

# 用作堡垒机所用cidr
variable "bastion_cidr" {
  type        = string
  description = "bastion subnet cidr block"
  validation {
    condition     = can(cidrnetmask("${var.bastion_cidr}"))
    error_message = "Must Input a CIDR Block"
  }
}
# 三个subnet的cidr block 列表
variable "public_cidr" {
  type        = list(string)
  description = "bastion subnet cidr block"
  validation {
    condition     = length([for cidr in var.public_cidr : cidrsubnet(cidr, 0, 0)]) == length(var.public_cidr)
    error_message = "Need every item is CIDR Block"
  }
}
variable "app_cidr" {
  type        = list(string)
  description = "app subnet cidr block"
  validation {
    condition     = length([for cidr in var.app_cidr : cidrsubnet(cidr, 0, 0)]) == length(var.app_cidr)
    error_message = "Need every item is CIDR Block"
  }
}
variable "db_cidr" {
  type        = list(string)
  description = "db subnet cidr block"
  validation {
    condition     = length([for cidr in var.db_cidr : cidrsubnet(cidr, 0, 0)]) == length(var.db_cidr)
    error_message = "Need every item is CIDR Block"
  }
}
# ############################# Task 4 ##################################
variable "sg_basic" {
  type = map(object({
    ingress = list(list(string))
    egress  = list(list(string))
  }))
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
  type        = list(any)
  description = "define sg chain "
  default = [
    ["elb", "app", "tcp", "8080", "8080"],
    ["app", "db", "tcp", "3306", "3306"],
    ["bastion", "app", "tcp", "22", "22"],
  ]
}

variable "db_config" {
  type        = map(string)
  description = "db config"
  default = {
    "storage"              = "10",
    "engine"               = "mysql",
    "engine_version"       = "5.7",
    "instance_class"       = "db.t3.micro",
    "parameter_group_name" = "default.mysql5.7",
    "multi_az"             = true,
    "skip_final_snapshot"  = true,
  }
}
variable "db_username" {
  type        = string
  description = "db_username"
  sensitive   = true
}
variable "db_password" {
  type        = string
  description = "db_username"
  sensitive   = true
}
# ############################# Task 5 ##################################
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