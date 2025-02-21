resource "aws_api_gateway_account" "apigateway" {
  cloudwatch_role_arn = aws_iam_role.apigateway_cloudwatch.arn
}

data "aws_iam_policy_document" "apigateway_cloudwatch_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "apigateway_cloudwatch" {
  name               = "api_gateway_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.apigateway_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "apigateway_cloudwatch_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "apigateway_cloudwatch_policy" {
  name   = "default"
  role   = aws_iam_role.apigateway_cloudwatch.id
  policy = data.aws_iam_policy_document.apigateway_cloudwatch_policy.json
}
