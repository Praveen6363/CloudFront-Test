provider "aws" {
  region = "us-east-1"
  access_key = "AKIA377XDWIH47D5KA6N"
  secret_key = "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"
}

resource "aws_s3_bucket" "praveen63_test"{
  bucket = "my-devops-internship-bucket-praveens"

  versioning {
     enabled = true
  }

  logging {
     target_bucket = "week-test-praveen"
  }
}

resource "aws_s3_bucket_ownership_controls" "control" {
  bucket = aws_s3_bucket.praveen63_test.id
  rule {
  object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_acess" {
  bucket = aws_s3_bucket.praveen63_test.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.praveen63_test.id
  key = "index.html"
  source = "/home/praveen-63/Desktop/index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.praveen63_test.id
  key = "error.html"
  source = "/home/praveen-63/Desktop/error.html"
  acl = "public-read"
}


resource "aws_s3_bucket_website_configuration" "static_hosting"{
  bucket = aws_s3_bucket.praveen63_test.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}



resource "aws_cloudfront_distribution" "example_distribution" {
  origin {
    domain_name = aws_s3_bucket.praveen63_test.website_endpoint
    origin_id   = "s3-origin"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html" 
  
  
  
  default_cache_behavior {
    target_origin_id = "s3-origin"
    
    viewer_protocol_policy = "redirect-to-https"
    
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
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

