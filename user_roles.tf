#################
# Developer
#################

resource "aws_iam_role" "developer" {
  name               = "developer"
  assume_role_policy = jsonencode(
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::126106299275:root"
              },
              "Action": "sts:AssumeRole"
          }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "developer_readwrite" {
  count      = var.developer_role_mode == "readwrite" ? 1 : 0
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy" "developer_readwrite_glue_pass_role" {
  count = var.developer_role_mode == "readwrite" ? 1 : 0
  name = "GluePassRole"
  role = aws_iam_role.developer.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "iam:PassRole"
        ],
        "Resource": aws_iam_role.glue_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "developer_readwrite_eks_role" {
  count = var.developer_role_mode == "readwrite" ? 1 : 0
  name = "EKSRolePolicy"
  role = aws_iam_role.developer.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "eks:*"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "iam:PassRole",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "iam:PassedToService": "eks.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "developer_readonly_eks_role" {
  count = var.developer_role_mode == "readonly" ? 1 : 0
  name = "EKSRolePolicy"
  role = aws_iam_role.developer.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "eks:AccessKubernetesApi",
          "eks:List*",
          "eks:Describe*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "developer_readonly" {
  count      = var.developer_role_mode == "readonly" ? 1 : 0
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#################
# QA
#################

resource "aws_iam_role" "qa" {
  name               = "qa"
  assume_role_policy = <<EOM
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::126106299275:root"
			},
			"Action": "sts:AssumeRole"
		}
	]
}
EOM
}

resource "aws_iam_role_policy_attachment" "qa_readonly" {
  role       = aws_iam_role.qa.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "qa_s3_readwrite" {
  count      = var.environment_name == "staging" ? 1 : 0
  role       = aws_iam_role.qa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#################
# Machine Learning
#################
resource "aws_iam_role" "machinelearning" {
  name               = "machinelearning"
  assume_role_policy = <<EOM
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::126106299275:root"
			},
			"Action": "sts:AssumeRole"
		}
	]
}
EOM
}

resource "aws_iam_role_policy_attachment" "ml_sagemakerfullaccess" {
  role       = aws_iam_role.machinelearning.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
