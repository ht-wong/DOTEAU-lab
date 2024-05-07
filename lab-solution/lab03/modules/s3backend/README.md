# S3 backend

自动化创建 Terraform 所用的 Remote State 模块

## Usage

```hcl
terraform {
  required_version = "~> 1.6"
  required_providers {}
}

module "s3_backend" {
  source            = "./modules/s3backend"
  region            = "ap-northeast-1"
  app               = "example"
  env               = "test"
  enable_versioning = false
}

output "region" {
  value = module.s3_backend.region
}

output "bucket" {
  value = module.s3_backend.bucket
}

output "dynamodb_table" {
  value = module.s3_backend.dynamodb_table
}

output "operator_role" {
  value = module.s3_backend.operator_role
}
```

## Requirements
| Name | Version |
|------|---------|
|terraform|~> 1.6|


## Providers

| Name | Version |
|------|---------|
|hashicorp/aws|5.47.0|
|hashicorp/template|2.2.0|
|hashicorp/random|3.6.1|

## Modules

No Modules

## Resources

| Name | Type |
|------|------|
|random_string.suffix|resource|
|aws_s3_bucket.this|resource|
|aws_s3_bucket_versioning.this|resource|
|aws_dynamodb_table.this|resource|
|template_file.operator_policy|resource|
|template/operator.json.tpl|tempalte|
|aws_iam_policy.state_operator|resource|
|aws_iam_role.operator_role|resource|
|aws_caller_identity.current|data source|

## Inputs
| Name | Description | Type | Default | Required |
|------|-----------------------------|------|---------|:--------:|
|region | Region|string |ap-northeast-1 |yes|
| app| Application Name|string | null|yes|
|env |Application Environment [prod/stage/test/dev] | string|null |yes|
|enable_versioning |Enable Bucket Versioning Config? | bool| true|yes|


## Outputs

| Name | Description |
|------|-------------|
| region| backend所在区域 |
|bucket | s3 bucket name |
| bucket_console| bucket web console 地址 |
|dynamodb_table | dbb table name|
|ddb_console |ddb table web console url |
|operator_role |可对此backend的role |