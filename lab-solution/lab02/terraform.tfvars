region       = "ap-northeast-1"
app          = "lab02"
env          = "dev"
vpc_cidr     = "10.0.0.0/16"
revision     = 1
bastion_cidr = "10.0.1.0/24"
public_cidr  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
app_cidr     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
db_cidr      = ["10.0.31.0/24", "10.0.32.0/24", ]
sg_basic = {
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
sg_chain = [
  ["elb", "app", "tcp", "8080", "8080"],
  ["app", "db", "tcp", "3306", "3306"],
  ["bastion", "app", "tcp", "22", "22"],
  ["bastion", "db", "tcp", "22", "22"],
]

db_username = "terraform"
db_password = "terraform-demo-db-passwd"
ssh_key     = "terraform"