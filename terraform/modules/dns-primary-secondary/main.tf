provider "aws" {
  region = var.region
}

resource "aws_route53_record" "active" {
  zone_id        = var.zone_id
  name           = ""
  type           = "A"
  set_identifier = "${var.domain_name}-active"
  health_check_id = aws_route53_health_check.active.id

  alias {
    name                   = var.active_alb_dns
    zone_id                = var.active_alb_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "passive" {
  zone_id        = var.zone_id
  name           = ""
  type           = "A"
  set_identifier = "${var.domain_name}-passive"

  alias {
    name                   = var.passive_alb_dns
    zone_id                = var.passive_alb_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}

resource "aws_route53_health_check" "active" {
  fqdn              = "${var.domain_name}"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "1"
  request_interval  = "10"

  tags = {
    Name = "failover-healthcheck"
  }
}