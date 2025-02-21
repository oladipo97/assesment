resource "aws_s3_bucket" "cache" {
  bucket =  "${var.environment_name}-120water-gitlab-cache"
}

resource "aws_s3_bucket_acl" "cache_acl" {
  bucket = aws_s3_bucket.cache.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cache_encryption" {
  bucket = aws_s3_bucket.cache.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "cache_policy" {
  statement {
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.cache.arn}/*"]
  }
}

resource "aws_iam_policy" "cache_policy" {
  name        =  "gitlab-cache-access"
  path        = "/"
  description = "Allows GitLab Runners to access S3 cache"

  policy = data.aws_iam_policy_document.cache_policy.json
}

resource "aws_iam_role_policy_attachment" "cache_access" {
  role       = aws_iam_role.gitlab_runners.name
  policy_arn = aws_iam_policy.cache_policy.arn
}