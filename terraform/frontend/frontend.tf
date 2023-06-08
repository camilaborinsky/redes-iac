resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

module "web-site" {
  source = "../modules/s3_4.0"
  bucket = var.bucket_name
  static_resources    = var.static_resources
  bucket_access_OAI   = [aws_cloudfront_origin_access_identity.oai.iam_arn]
}


module "cdn" {
  source = "../modules/cloudfront"

  domain_name        = var.domain_name
  bucket_regional_domain_name = module.web-site.s3_bucket_regional_domain_name
  bucket_id          = module.web-site.s3_bucket_id
  aliases            = ["www.${var.domain_name}", var.domain_name]
  cloudfront_oai_path = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
  # certificate_arn    = module.certificate.arn
}


module "dns" {
  source = "../modules/dns"
  base_domain = var.domain_name
  cdn = {
    hosted_zone_id = module.cdn.hosted_zone_id
    domain_name    = module.cdn.domain_name
  }
}