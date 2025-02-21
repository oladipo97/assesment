module "athena_s3_bucket" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//s3?ref=v1.3.1"
  providers = {
    aws            = aws
  }
  bucket_name = "120water-athena-queries-${var.environment_name}"
  canned_acl = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_s3_lifecycle" {
  depends_on = [ module.athena_s3_bucket ]
  bucket = "120water-athena-queries-${var.environment_name}"
  rule {
    id = "expiration"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

resource "aws_athena_workgroup" "athena_event_ledger_workgroup" {
  name = "event_ledger"

  configuration {
    enforce_workgroup_configuration    = false
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://120water-athena-queries-${var.environment_name}/eventledger"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}
