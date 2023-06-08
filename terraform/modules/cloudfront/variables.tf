variable "domain_name" {
  description = "target domain name of the S3 bucket"
  type = string
}

variable "bucket_regional_domain_name" {
  description = "target domain name of the S3 bucket"
  type = string
}
variable "bucket_id" {
  description = "target domain name of the S3 bucket"
  type = string
}
variable "aliases" {
  description = "Aliases for the distribution"
  type = set(string)
  default = []
}

variable "cloudfront_oai_path" {
  description = "The ID of the OAI"
  type = string
}
variable "certificate_arn" {
  description = "The ARN of the certificate"
  type = string
}

variable "region" {
  description = "The region to deploy to"
  type = string
  default = "us-east-1"
}