# Meta Cofig
variable "region" {
  type        = string
  description = "Region"
  default     = "ap-northeast-1"
}
variable "app" {
  type        = string
  description = "Application Name"
}
variable "env" {
  type        = string
  description = "Application Environment [prod/stage/test/dev]"
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
# S3 Bucket Config
variable "enable_versioning" {
  type        = bool
  description = "Enable Bucket Versioning Config?"
  default     = true
}

# DDB Config

# IAM Config