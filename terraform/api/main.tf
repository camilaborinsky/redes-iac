# For our 'active' region.


#provider "aws" {
#  region = "us-east-1"
#}

#data "aws_route53_zone" "this" {
#  name = "${var.subdomain_name}.${var.domain_name}"
#}

module "active-network" {
  source = "../modules/network"
  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = "redes-vpc"
  ec2_api_port = 5000
  region      = "us-east-1"
}

#module "passive-network" {
#  source = "./modules/network"
#  vpc_cidr     = "10.0.0.0/16"
#  vpc_name     = "redes-vpc"
#  ec2_api_port = 5000
#  region      = "us-east-1"
#}
#module "dns-active-passive" {
#  source = "./modules/dns-primary-secondary"
#  region = "us-east-1"
#  zone_id = ""
#  primary_alb_dns = ""
#  primary_alb_zone_id = ""
#  secondary_alb_dns = ""
#  secondary_alb_zone_id = ""
#  domain_name = ""
 # subdomain_name = ""
#}

