variable "region" {
  description = "AWS region"
  type        = string
}

variable "zone_id" {
  description = "AWS Route53 zone ID"
  type        = string
}

variable "primary_alb_dns" {
  description = "Primary ALB DNS name"
  type        = string
}

variable "secondary_alb_dns" {
  description = "Secondary ALB DNS name"
  type        = string
}

variable "primary_alb_zone_id" {
  description = "Primary ALB zone ID"
  type        = string
}

variable "secondary_alb_zone_id" {
  description = "Secondary ALB zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "subdomain_name" {
  description = "Subdomain name"
  type        = string
}#