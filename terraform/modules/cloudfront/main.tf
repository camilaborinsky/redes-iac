data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  # Si se usa www hay problemas de permisos, la policy dice que solo cloudfront lee pega a site
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_id

    s3_origin_config {
      origin_access_identity = var.cloudfront_oai_path
    }
    origin_shield {
      enabled              = false
      origin_shield_region = var.region
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "cdn"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = var.aliases

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.bucket_id
    cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
    viewer_protocol_policy = "allow-all"
    # forwarded_values {
    #   headers      = []
    #   query_string = true
    #   cookies {
    #     forward = "all"
    #   }
    # }
  }



  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = var.certificate_arn
    ssl_support_method = "sni-only"
  }
}