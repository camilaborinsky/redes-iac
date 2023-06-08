# For our 'active' region.


provider "aws" {
  region = "us-east-1"
}

data "aws_route53_zone" "this" {
  name = "${var.domain_name}"
}

module "active-network" {
  source = "../modules/network"
  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = "redes-vpc"
  ec2_api_port = 5000
  region      = "us-east-1"
}

module "passive-network" {
  source = "../modules/network"
  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = "redes-vpc"
  ec2_api_port = 5000
  region      = "us-east-2"
}

module "dns-active-passive" {
  source = "../modules/dns-primary-secondary"
  region = "us-east-1"
  zone_id = data.aws_route53_zone.this.zone_id
  active_alb_dns = module.active-network.alb_dns
  active_alb_zone_id = module.active-network.alb_zone_id
  passive_alb_dns = module.passive-network.alb_dns
  passive_alb_zone_id = module.passive-network.alb_zone_id
  domain_name = var.domain_name
}

