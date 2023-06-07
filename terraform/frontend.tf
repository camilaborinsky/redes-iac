module "s3-frontend" {
  source   = "./modules/s3_4.0"

  providers = {
    aws = aws.aws
  }

  bucket_name       = "frontend-s3"
  objects           = {}
  bucket_acl        = "private"
  index_file        = "index.html"
  redirect_hostname = null
}

module "s3-www-frontend" {
    source   = "./modules/s3_4.0"

    providers = {
        aws = aws.aws
    }

    bucket_name       = "www-frontend-s3"
    objects           = {}
    bucket_acl        = "private"
    index_file        = "index.html"
    redirect_hostname = "frontend-s3.s3-website-us-east-1.amazonaws.com"
}

module "s3-frontend-logs" {
    source   = "./modules/s3_4.0"

    providers = {
        aws = aws.aws
    }

    bucket_name       = "frontend-logs-s3"
    objects           = {}
    bucket_acl        = "log-delivery-write"
    index_file        = null
    redirect_hostname = "frontend-s3.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket_logging" "landing-page-dev-logging" {
    depends_on = [ module.s3-frontend-logs,module.s3-frontend ]
  bucket = module.s3-frontend.id

  target_bucket = module.s3-frontend-logs.id
  target_prefix = "log/"
}


## CloudFront Distribuition
module "cloudfront-landing-page-dev" {
  source = "./modules/cloudfront"
  providers = {
    aws = aws
  }
  depends_on = [
    module.s3-frontend-logs,module.s3-frontend,
  ]
  origin = {
    landing-page-dev = {
      domain_name = module.s3-frontend.website_endpoint
      #origin_id = "${local.s3_landing_page_dev.website.bucket_name}"
      origin_id = "frontend-s3"

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    www-landing-page-dev = {
      domain_name = module.s3-www-frontend.website_endpoint
      origin_id   = "www.frontend-s3}"

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  custom_error_response = {
    default = {
      error_caching_min_ttl = 0
      error_code            = 404
      response_code         = 200
      response_page_path    = "/404.html"
  } }

  default_cache_behavior = {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontend-s3"

    forwarded_values = {
      query_string = false

      cookies = {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
  }

  geo_restriction = {
    geo_restriction = {
      restriction_type = "none"
    }
  }

#   viewer_certificate = {
#     acm_certificate_arn      = module.acm[local.domain_name].acm_certificate_arn
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.1_2016"
#   }
}