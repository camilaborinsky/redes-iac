output "alb_dns" {
    value = module.alb.lb_dns_name
}

output "alb_zone_id" {
    value = module.alb.lb_zone_id
}