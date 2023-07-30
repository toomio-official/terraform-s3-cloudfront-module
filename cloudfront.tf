resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.cloudfront_distribution_description
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  comment = var.cloudfront_distribution_description

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = var.s3_bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_document

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  aliases = var.domain_names

  dynamic "custom_error_response" {
    for_each = var.error_document != null ? var.custom_error_response_codes : []
    iterator = custom_error_response_code
    content {
      error_code            = custom_error_response_code.value
      error_caching_min_ttl = 10
      response_code         = custom_error_response_code.value
      response_page_path    = "/${var.error_document}"
    }
  }
}

