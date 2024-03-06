resource "aws_s3_object" "static_external_js" {
  for_each     = fileset("./static_external", "**.js")
  bucket       = local.bucket_name
  key          = "static_external/${each.value}"
  source       = "${path.module}/static_external/${each.value}"
  etag         = filemd5("${path.module}/static_external/${each.value}")
  content_type = "application/json"
  acl          = "public-read"
}

resource "aws_cloudfront_response_headers_policy" "static_external" {
  count   = local.is_universal ? 0 : 1
  name    = "universal_static_external"
  comment = "static external to allow embedding into a third party site"

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["GET"]
    }

    access_control_allow_origins {
      items = ["*"]
    }
    origin_override = true
  }
  security_headers_config {
    content_security_policy {
      content_security_policy = "default-src 'none'; frame-src '*'; report-uri https://gqt9qhf3ea.execute-api.us-east-1.amazonaws.com/prod/report"
      override                = false
    }
  }
}
