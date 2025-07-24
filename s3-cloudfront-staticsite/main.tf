resource "aws_s3_bucket" "tfbucket"{
    bucket = "testtfbktforcfsite"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.tfbucket.id
  for_each = fileset("aws-s3-static-website-sample/Website/", "**/*.*")

    key    = each.value
    source = "aws-s3-static-website-sample/Website/${each.value}"

  
}
resource "aws_s3_bucket_public_access_block" "landing_page_public_access" {
  bucket = aws_s3_bucket.tfbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.tfbucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
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

resource "aws_s3_bucket_policy" "landing_page_bucket_policy" {
  bucket = aws_s3_bucket.tfbucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowGetObj",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.tfbucket.id}/*"
    }
  ]
}
POLICY
}
