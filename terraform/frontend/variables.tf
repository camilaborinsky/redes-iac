variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "bucket_name"{
  type        = string
  description = "Bucket Name"
}

variable "static_resources" {
  type        = string
  description = "Static Resources"
}