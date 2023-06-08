# Output variable definitions

output "cloudfront_distribution" {
  description = "The cloudfront distribution for the deployment"
  value       = aws_cloudfront_distribution.this
}

output "hosted_zone_id" {
  description = "The hosted zone id for the domain"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "domain_name" {
  description = "The domain name for the distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}