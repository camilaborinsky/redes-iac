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

variable "ec2_api_port" {
  type        = number
  description = "EC2 API port"
}