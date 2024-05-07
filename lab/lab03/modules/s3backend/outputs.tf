# ################################### TASK 1 ################################### 
/*
output "region" {}
output "bucket" {}
output "bucket_console" {
  value = local.s3_console
}
*/
# ################################### TASK 2 ################################### 
/*
output "dynamodb_table" {}
output "ddb_console" {
  value = local.ddb_console
}
*/
# ################################### TASK 3 ################################### 
/*
output "operator_role" {
  value = aws_iam_role.operator_role.arn
}
*/