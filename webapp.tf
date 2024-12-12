resource "aws_cognito_user_pool" "pool" {
  name                     = var.cognito_user_pool
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name         = var.cognito_user_pool_client
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_s3_bucket" "web_app_bucket" {
  bucket = var.web_app_deployment_bucket

  tags = {
    Name = var.web_app_deployment_bucket
  }

}

resource "aws_s3_bucket_website_configuration" "web_app_website" {
  bucket = aws_s3_bucket.web_app_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.web_app_bucket.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership_controls]
  bucket     = aws_s3_bucket.web_app_bucket.id
  acl        = "private"
}
