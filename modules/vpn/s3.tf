resource "aws_s3_bucket" "config_bucket" {
  bucket = "120water-vpn-${var.environment_name}"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.config_bucket.bucket
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.config_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "vpn_config" {
  bucket  = aws_s3_bucket.config_bucket.bucket
  key     = "wg0.conf"
  content = local.vpn_config
  etag    = md5(local.vpn_config)
}