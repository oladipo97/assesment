resource "aws_cloudwatch_log_group" "auth0_events" {
  name = "/auth0/events"
  tags = {
    System = "auth0"
  }
  retention_in_days = 365
}

resource "aws_cloudwatch_log_resource_policy" "auth0_events_log_resource_policy" {
  policy_name     = "auth0-events-log-resource-policy"
  policy_document = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "events.amazonaws.com",
            "delivery.logs.amazonaws.com"
          ]
        },
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:log-group:/auth0/events:log-stream:*"
      }
    ]
  })
  depends_on = [
    aws_cloudwatch_log_group.auth0_events,
    aws_cloudwatch_event_rule.auth0_event_rule_to_cloudwatch
  ]
}

resource "aws_cloudwatch_event_rule" "auth0_event_rule_to_cloudwatch" {
  name        = "auth0-event-rule-to-cloudwatch"
  description = "Transfer auth0 events to cloudwatch log group"
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

resource "aws_cloudwatch_event_target" "auth0_events_cloudwatch_target" {
  rule            = aws_cloudwatch_event_rule.auth0_event_rule_to_cloudwatch.name
  arn             = aws_cloudwatch_log_group.auth0_events.arn
  event_bus_name  = aws_cloudwatch_event_bus.auth0_eventbridge.name
  depends_on = [
    aws_cloudwatch_event_rule.auth0_event_rule_to_cloudwatch,
    aws_cloudwatch_log_group.auth0_events
  ]
}