resource "aws_s3_bucket" "tfbucket"{
    bucket = "testtfbktforcfsite"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.tfbucket.id
  for_each = fileset("aws-s3-static-website-sample/Website/", "**/*.*")
    key    = each.value
    source = "aws-s3-static-website-sample/Website/${each.value}"  
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.tfbucket.bucket_regional_domain_name
    origin_id                = "s3-website-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-website-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
