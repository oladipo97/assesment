data "aws_subnet" "gitlab_runner_subnet" {
  id = element(var.subnet_ids, 0)
}

resource "aws_security_group" "gitlab_runners" {
  name        = "gitlab_runners"
  description = "GitLab Runners"
  vpc_id      = data.aws_subnet.gitlab_runner_subnet.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    self        = true
    description = "SSH"
  }

  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "TCP"
    self        = true
    description = "Docker API"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gitlab_runners"
  }
}

resource "aws_instance" "orchestrator" {
  ami                    = "ami-02fc6052104add5ae"
  instance_type          = "t3a.micro"
  iam_instance_profile   = aws_iam_instance_profile.gitlab_runners.name
  subnet_id              = element(var.subnet_ids, 0)
  vpc_security_group_ids = [aws_security_group.gitlab_runners.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "gitlab_runner_orchestrator"
  }
}

resource "aws_iam_instance_profile" "gitlab_runners" {
  name = "gitlab_runners"
  role = aws_iam_role.gitlab_runners.name
}

resource "aws_iam_role" "gitlab_runners" {
  name = "gitlab_runners"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.gitlab_assume_role.json
}

data "aws_iam_policy_document" "gitlab_assume_role" {
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
  role       = aws_iam_role.gitlab_runners.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.gitlab_runners.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "gitlab_runner_security_group_id" {
  value = aws_security_group.gitlab_runners.id
}