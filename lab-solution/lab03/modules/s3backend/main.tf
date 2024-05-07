resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
}

# Bucket
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# DDB 
resource "aws_dynamodb_table" "this" {
  name         = local.ddb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# IAM: Operator
data "template_file" "operator_policy" {
  template = file("${path.module}/template/operator.json.tpl")
  vars = {
    bucket_name = aws_s3_bucket.this.id
    region      = var.region
    table_name  = aws_dynamodb_table.this.id
  }
}

resource "aws_iam_policy" "state_operator" {
  name   = join("-", [local.prefix, "operatorPolicy", local.suffix])
  path   = "/"
  policy = data.template_file.operator_policy.rendered
}

# Role
resource "aws_iam_role" "operator_role" {
  name                = join("-", [local.prefix, "operatorRole", local.suffix])
  managed_policy_arns = [aws_iam_policy.state_operator.arn]
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