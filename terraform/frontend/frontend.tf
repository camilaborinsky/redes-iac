provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name = var.domain_name
}
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

module "web-site" {
  source = "../modules/s3_4.0"
  bucket = var.bucket_name
  static_resources    = var.static_resources
  bucket_access_OAI   = [aws_cloudfront_origin_access_identity.oai.iam_arn]
}


module "acm" {
    source= "../modules/acm"
    domain_name = var.domain_name
    subject_alternative_names = [ "www.${var.domain_name}"]
    zone_id = data.aws_route53_zone.this.zone_id
    wait_for_validation = false
}

module "cdn" {
  depends_on = [ module.acm ]
  source = "../modules/cloudfront"
  region = data.aws_region.current.name
  domain_name        = var.domain_name
  bucket_regional_domain_name = module.web-site.s3_bucket_regional_domain_name
  bucket_id          = module.web-site.s3_bucket_id
  aliases            = ["www.${var.domain_name}", var.domain_name]
  cloudfront_oai_path = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    certificate_arn    = module.acm.acm_certificate_arn
}

resource "aws_route53_record" "base" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.cdn.domain_name
    zone_id                = module.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 900

  records = ["${var.domain_name}"]

  depends_on = [
    aws_route53_record.base
  ]
}
