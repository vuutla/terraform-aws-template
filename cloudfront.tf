resource "aws_s3_bucket" "web_endpoint" {
  bucket = "web_endpoint"
  acl    = "private"

  website {
    index_document = "index.html"
  }
}

# To print the bucket's website URL after creation
output "web_endpoint" {
  value = aws_s3_bucket.web_endpoint.website_endpoint
}

resource "aws_cloudfront_distribution" "tf" {
  origin {
    domain_name = aws_s3_bucket.web_endpoint.bucket_domain_name
    

    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
  }
}