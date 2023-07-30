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

  enabled         = true
  is_ipv6_enabled = true

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

  custom_error_response {
    error_code            = 400
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 10
    response_code         = 200
    response_page_path    = "/${var.index_document}"
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 405
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 414
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 416
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 500
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 501
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 502
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 503
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 504
    error_caching_min_ttl = 10
  }
}

