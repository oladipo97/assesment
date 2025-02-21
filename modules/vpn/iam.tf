resource "aws_iam_instance_profile" "vpn" {
  name = "vpn"
  role = aws_iam_role.vpn.name
}

resource "aws_iam_role" "vpn" {
  name = "vpn"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.vpn_assume_role.json
}

data "aws_iam_policy_document" "vpn_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.vpn.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "s3" {
  name        = "vpn_s3"
  path        = "/"
  description = "VPN S3 Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.config_bucket.bucket}/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.vpn.name
  policy_arn = aws_iam_policy.s3.arn
}