data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "platform_events_topic" {
  name = "${var.environment_name}-platform-events-topic"
}

data "aws_iam_policy_document" "platform_events_topic_policy" {
  # The default/required access
  statement {
    sid    = "default"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:AddPermission",
      "SNS:Subscribe",
    ]

    resources = [
      aws_sns_topic.platform_events_topic.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "platform_events_topic_policy" {
  arn    = aws_sns_topic.platform_events_topic.arn
  policy = data.aws_iam_policy_document.platform_events_topic_policy.json
}

resource "aws_sns_topic" "platform_events_topic_fifo" {
  name = "platform-events-topic-${var.environment_name}.fifo"
  fifo_topic = true
  content_based_deduplication = true
}

data "aws_iam_policy_document" "platform_events_topic_fifo_policy" {
  # The default/required access
  statement {
    sid    = "default"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:AddPermission",
      "SNS:Subscribe",
    ]

    resources = [
      aws_sns_topic.platform_events_topic_fifo.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "platform_events_topic_fifo_policy" {
  arn    = aws_sns_topic.platform_events_topic_fifo.arn
  policy = data.aws_iam_policy_document.platform_events_topic_fifo_policy.json
}
