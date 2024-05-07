terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}
variable "region" {}

module "s3_backend" {
  source = "./modules/s3backend"

  region            = var.region
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

output "bucket_console" {
  value = module.s3_backend.bucket_console
}

output "dynamodb_table" {
  value = module.s3_backend.dynamodb_table
}

output "ddb_console" {
  value = module.s3_backend.ddb_console
}

output "operator_role" {
  value = module.s3_backend.operator_role
}