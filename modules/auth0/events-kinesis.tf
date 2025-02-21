data "aws_ssm_parameter" "auth0_events_transform_bucket" {
  name = "/service/auth0-events-transform-lambda/artifact_bucket"
}

data "aws_ssm_parameter" "auth0_events_transform_role_name" {
  name = "/service/auth0-events-transform-lambda/role_name"
}

data "aws_iam_role" "auth0_events_transform_role" {
  name = data.aws_ssm_parameter.auth0_events_transform_role_name.value
}

resource "aws_iam_role_policy_attachment" "auth0_events_transform_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = data.aws_iam_role.auth0_events_transform_role.name
}

resource "aws_iam_role_policy" "auth0_events_transform_role_policy_sns" {
  name   = "sns"
  role   = data.aws_iam_role.auth0_events_transform_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : [
          var.sns_audit_topic_arn
        ]
      },
    ]
  })
}

resource "aws_lambda_function" "auth0_events_transform_lambda" {
  function_name = "auth0_events_transform_lambda"
  role              = data.aws_iam_role.auth0_events_transform_role.arn
  s3_bucket         = data.aws_ssm_parameter.auth0_events_transform_bucket.value
  s3_key            = "${var.commit_sha}.zip"
  handler           = "auth0_transform.lambda_handler"
  runtime           = "python3.10"
  timeout           = 300
  environment {
    variables = {
      AUTH0_TENANT_DOMAIN = var.auth0_tenant_domain
      AUTH0_CLIENT_ID = var.auth0_client_id
      AUTH0_CLIENT_SECRET = var.auth0_client_secret
      SNS_AUDIT_TOPIC = var.sns_audit_topic_arn
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "auth0-events-firehose-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "firehose_role_policy" {
  role   = aws_iam_role.firehose_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": [
          var.snowflake_s3_bucket,
          "${var.snowflake_s3_bucket}/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource": [
          "${aws_lambda_function.auth0_events_transform_lambda.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "auth0_events_kinesis_stream" {
  name = "auth0-events-firehose-stream"
  destination = "extended_s3"
  server_side_encryption {
    enabled = true
    key_type = "AWS_OWNED_CMK"
  }

  extended_s3_configuration {
    bucket_arn = var.snowflake_s3_bucket
    role_arn   = aws_iam_role.firehose_role.arn

    prefix              = "events/auth0/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/!{timestamp:HH}/"
    error_output_prefix = "events/errors/auth0/!{firehose:error-output-type}/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/!{timestamp:HH}/"

    processing_configuration {
      enabled = "true"
      processors {
        type = "Lambda"
        parameters {
          parameter_name = "LambdaArn"
          parameter_value = "${aws_lambda_function.auth0_events_transform_lambda.arn}:$LATEST"
        }
      }
    }
  }
}

resource "aws_cloudwatch_event_rule" "auth0_event_rule_to_kinesis" {
  name        = "auth0-event-rule-to-kinesis"
  description = "Transfer auth0 events to kinesis"
  event_bus_name = aws_cloudwatch_event_bus.auth0_eventbridge.name
  event_pattern = jsonencode({
    "source": [{
      "prefix": "aws.partner/auth0.com"
    }]
  })
  depends_on = [
    aws_cloudwatch_event_bus.auth0_eventbridge
  ]
}

resource "aws_iam_role" "auth0_events_eventbridge_to_kinesis" {
  name = "auth0-events-eventbridge-to-kinesis-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "auth0_events_eventbridge_to_kinesis_policy" {
  role   = aws_iam_role.auth0_events_eventbridge_to_kinesis.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Resource": [ aws_kinesis_firehose_delivery_stream.auth0_events_kinesis_stream.arn ]
      }
    ]
  })
}

resource "aws_cloudwatch_event_target" "auth0_events_kinesis_target" {
  rule            = aws_cloudwatch_event_rule.auth0_event_rule_to_kinesis.name
  arn             = aws_kinesis_firehose_delivery_stream.auth0_events_kinesis_stream.arn
  role_arn        = aws_iam_role.auth0_events_eventbridge_to_kinesis.arn
  event_bus_name  = aws_cloudwatch_event_bus.auth0_eventbridge.name
  depends_on = [
    aws_cloudwatch_event_rule.auth0_event_rule_to_cloudwatch,
    aws_cloudwatch_log_group.auth0_events
  ]
}
