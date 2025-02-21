module "event-ledger-s3-bucket" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//s3?ref=v1.3.1"
  providers = {
    aws            = aws
  }
  bucket_name = "120water-event-ledger-${var.environment_name}"
  canned_acl = "private"
}

resource "aws_qldb_ledger" "event-ledger" {
  name              = "event-ledger"
  permissions_mode  = "STANDARD"
}

resource "aws_kinesis_stream" "event-ledger-kinesis-stream" {
  name             = "event-ledger-kinesis-stream"
  encryption_type = "KMS"
  kms_key_id = "alias/aws/kinesis"
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_iam_role" "event-ledger-kinesis-s3-delivery-stream-role" {
  name               = "event-ledger-kinesis-s3-delivery-stream-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "firehose.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "DeliveryPermissions"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Action": [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
          ],
          "Resource": [
            "arn:aws:s3:::120water-event-ledger-${var.environment_name}",
            "arn:aws:s3:::120water-event-ledger-${var.environment_name}/*"
          ]
        },
        {
          "Sid": "",
          "Effect": "Allow",
          "Action": [
            "logs:PutLogEvents"
          ],
          "Resource": [
            "*",
          ]
        },
        {
          "Sid": "",
          "Effect": "Allow",
          "Action": [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
          ],
          "Resource": aws_kinesis_stream.event-ledger-kinesis-stream.arn
        },
        {
          "Effect": "Allow",
          "Action": [
            "kms:Decrypt"
          ],
          "Resource": [
            "*"
          ]
        }
      ]
    })
  }
}

resource "aws_cloudwatch_log_group" "event-ledger-kinesis-s3-delivery-stream-logging-group" {
  name = "/aws/kinesisfirehose/event-ledger-kinesis-s3-delivery-stream"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "event-ledger-kinesis-s3-delivery-stream-logging-stream" {
  log_group_name = aws_cloudwatch_log_group.event-ledger-kinesis-s3-delivery-stream-logging-group.name
  name           = "eventledgers3delivery"
}

resource "aws_kinesis_firehose_delivery_stream" "event-ledger-kinesis-s3-delivery-stream" {
  name        = "event-ledger-kinesis-s3-delivery-stream"
  destination = "extended_s3"
  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.event-ledger-kinesis-stream.arn
    role_arn           = aws_iam_role.event-ledger-kinesis-s3-delivery-stream-role.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.event-ledger-kinesis-s3-delivery-stream-role.arn
    bucket_arn = "arn:aws:s3:::120water-event-ledger-${var.environment_name}"
    buffering_interval = 300
    buffering_size = 5
    
    prefix              = "logs/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "errors/"
    cloudwatch_logging_options {
      enabled = true
      log_group_name  = aws_cloudwatch_log_group.event-ledger-kinesis-s3-delivery-stream-logging-group.name
      log_stream_name = aws_cloudwatch_log_stream.event-ledger-kinesis-s3-delivery-stream-logging-stream.name
    }
  }
}

resource "aws_iam_role" "event-ledger-stream-role" {
  name               = "event-ledger-stream-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "qldb.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
  inline_policy {
    name = "KinesisPermissions"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "KinesisPermissions",
          "Action": [
            "kinesis:PutRecord*",
            "kinesis:DescribeStream",
            "kinesis:ListShards"
          ],
          "Effect": "Allow",
          "Resource": aws_kinesis_stream.event-ledger-kinesis-stream.arn
        }
      ]
    })
  }
}

resource "aws_qldb_stream" "event-ledger-stream" {
  ledger_name          = aws_qldb_ledger.event-ledger.name
  stream_name          = "event-ledger-stream"
  role_arn             = aws_iam_role.event-ledger-stream-role.arn
  inclusive_start_time = "2024-01-01T00:00:00Z"

  kinesis_configuration {
    aggregation_enabled = true
    stream_arn          = aws_kinesis_stream.event-ledger-kinesis-stream.arn
  }
}

