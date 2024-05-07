# Meta Config
output "region" {
  value = var.region
}
# S3 Bucket
output "bucket" {
  value = aws_s3_bucket.this.id
}
output "bucket_console" {
  value = local.s3_console
}
# DDB config
output "dynamodb_table" {
  value = aws_dynamodb_table.this.id
}
output "ddb_console" {
  value = local.ddb_console
}

output "operator_role" {
  value = aws_iam_role.operator_role.arn
}