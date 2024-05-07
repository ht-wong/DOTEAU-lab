# ################################### TASK 1 ################################### 
/*
# random-suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
}

# Bucket
resource "aws_s3_bucket" "this" {
  # Bucket Name ：[env]-[app]-state-bucket-suffix
  bucket = local.bucket_name
}
# Bucket Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = 
  versioning_configuration {
  # 参数可以是 Enabled or Disabled
    status = 
  }
}
*/
# ################################### TASK 2 ################################### 
/*
# DDB 
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "this" {
  # Table Name ：[env]-[app]-state-lock-table-suffix
  name         = local.ddb_name
}
*/
# ################################### TASK 3 ################################### 
/*
# IAM: Operator
data "template_file" "operator_policy" {}

resource "aws_iam_policy" "state_operator" {
  # Policy Name ：[env]-[app]-operatorPolicy-suffix
  name   = 
  path   = "/"
  policy = data.template_file.operator_policy.rendered
}

# Role
resource "aws_iam_role" "operator_role" {
  # Role Name ：[env]-[app]-operatorRole-suffix
  name                = join("-", [local.prefix, "operatorRole", local.suffix])
  managed_policy_arns = 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.account_id}"
        },
        "Condition" : {}
      },
    ]
  })
}
*/