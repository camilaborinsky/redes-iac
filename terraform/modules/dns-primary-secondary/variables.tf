variable "region" {
  description = "AWS region"
  type        = string
}

variable "zone_id" {
  description = "AWS Route53 zone ID"
  type        = string
}

variable "active_alb_dns" {
  description = "active ALB DNS name"
  type        = string
}

variable "passive_alb_dns" {
  description = "passive ALB DNS name"
  type        = string
}

variable "active_alb_zone_id" {
  description = "active ALB zone ID"
  type        = string
}

variable "passive_alb_zone_id" {
  description = "passive ALB zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}