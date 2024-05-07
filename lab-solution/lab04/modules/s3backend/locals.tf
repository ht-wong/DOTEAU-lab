locals {
  suffix      = lower(random_string.suffix.result)
  prefix      = join("-", [var.env, var.app])
  bucket_name = join("-", [local.prefix, "state-bucket", local.suffix])
  s3_console  = "https://${var.region}.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.this.id}"
  ddb_name    = join("-", [local.prefix, "state-lock-table", local.suffix])
  ddb_console = "https://${var.region}.console.aws.amazon.com/dynamodbv2/home?region=${var.region}#table?name=${aws_dynamodb_table.this.id}"
}