# [模块名称]

[模块的用途和简介]

## Usage

[模块使用的样例]

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

[模块使用对于Terraform版本的要求]

| Name | Version |
|------|---------|
|terraform|~> 1.6|



## Providers

[模块使用对于Provider版本的要求]

| Name | Version |
|------|---------|
|hashicorp/aws|5.47.0|
|hashicorp/template|2.2.0|
|hashicorp/random|3.6.1|

## Modules

[是否存在子模块，如果存在的话请将子模块的路径写于此]

No Modules

## Resources

[模块的资源列表]

| Name | Type |
|------|------|
|aws_s3_bucket.this|resource|
|template/operator.json.tpl|tempalte|
|aws_caller_identity.current|data source|

## Inputs

[模块的Inputs Spec 描述]

| Name | Description | Type | Default | Required |
|------|-----------------------------|------|---------|:--------:|
| app| Application Name|string | null|yes|


## Outputs

[模块的Output描述]

| Name | Description |
|------|-------------|
|bucket | s3 bucket name |
