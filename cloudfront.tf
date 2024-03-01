data "aws_cloudfront_cache_policy" "aws_managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "aws_managed_cors_s3" {
  name = "Managed-CORS-S3Origin"
}

# Todo if this gets replaced in universal, enable static content serving only if authenticated
#resource "aws_cloudfront_origin_access_control" "universal" {
#  name                              = "universal_static_content"
#  description                       = "Universal static content"
#  origin_access_control_origin_type = "s3"
#  signing_behavior                  = "always"
#  signing_protocol                  = "sigv4"
#}

# tfsec:ignore:aws-cloudfront-enable-logging No logging exists in the universal account
resource "aws_cloudfront_distribution" "universal" {
  count = local.is_universal ? 0 : 1
  origin {
    domain_name = module.s3_bucket[0].bucket_regional_domain_name
    origin_path = ""
    origin_id   = local.bucket_name
  }

  enabled      = true
  comment      = "Universal static content"
  http_version = "http2and3"

  #aliases = ["universal.${data.aws_caller_identity.current.id}.hellopublic.com"]

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.bucket_name
    cache_policy_id          = data.aws_cloudfront_cache_policy.aws_managed_caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.aws_managed_cors_s3.id

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.bucket_name

    cache_policy_id          = data.aws_cloudfront_cache_policy.aws_managed_caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.aws_managed_cors_s3.id

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = true
  }
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${self.id} --paths '/*'"
  }
}
