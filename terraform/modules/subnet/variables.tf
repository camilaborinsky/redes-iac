// Subtnet variables
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet"
}

variable "cidr_block" {
  description = "CIDR block of the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone of the subnet"
  type        = string
}

variable "tags" {
  description = "Tags of the subnet"
  type        = map(string)
  default     = {}
}

variable "ng_id" {
  description = "NAT gateway ID"
  type        = string
  default     = null
}

variable "ig_id" {
  description = "Internet gateway ID"
  type        = string
  default     = null
}