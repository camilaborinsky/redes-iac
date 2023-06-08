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

variable "region" {
  type        = string
  description = "AWS Region"
}