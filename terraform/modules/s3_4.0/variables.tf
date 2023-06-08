# Input variable definitions

variable "static_resources" {
  description = "path to static resources"
  type        = string
}

variable "bucket_access_OAI" {
  description = "OAI of authorized bucket accessors"
  type        = list(string)
}

variable "bucket" {
  type        = string
  description = "The name of the bucket"
}

variable "bucket_acl" {
  type        = string
  default     = "private" 
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private. For more information about these settings, see the AWS S3 documentation: https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl"
}

variable "index_file" {
  type        = string
  default     = null
  description = "This is the index file in case the bucket is used for static website hosting"
}


variable "redirect_hostname" {
  type        = string
  default     = null
  description = "This is the redirect hostname in case the bucket needs to redirect its requests elsewhere"
}