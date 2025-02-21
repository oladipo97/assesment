module "auth0" {
  source = "./modules/auth0"

  aws_account_id            = var.aws_account_id
  aws_region                = var.aws_region
  auth0_tenant_domain       = var.auth0_tenant_domain
  auth0_client_id           = var.auth0_client_id
  auth0_client_secret       = var.auth0_client_secret
  snowflake_s3_bucket       = var.snowflake_platform_s3_bucket
  commit_sha                = var.commit_sha
  state_dashboard_hostnames = var.state_dashboard_hostnames
  hydra_hostnames           = var.hydra_hostnames
  sns_audit_topic_arn       = aws_sns_topic.platform_events_topic_fifo.arn
}

module "auth0_authorization_extension_data_bucket" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//s3?ref=v1.3.1"
  providers = {
    aws            = aws
  }
  bucket_name = "120water-auth0-authorization-extension-data-${var.environment_name}"
  canned_acl = "private"
}

resource "aws_iam_user" "auth0" {
  name = "auth0"
  tags = {
    tag-key = "auth0"
  }
}

resource "aws_iam_user_policy" "auth0_user_policy" {
  depends_on = [  module.auth0_authorization_extension_data_bucket, 
                  aws_iam_user.auth0]
  name   = "auth0_policy"
  user   = aws_iam_user.auth0.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        "Resource": [
          "arn:aws:s3:::120water-auth0-authorization-extension-data-${var.environment_name}/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::120water-auth0-authorization-extension-data-${var.environment_name}"
        ],
        "Condition": {}
      }
    ]
  })
}


