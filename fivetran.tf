resource "aws_security_group" "fivetran_proxy_agent" {
  name        = "fivetran_proxy_agent_sg"
  description = "fivetran_proxy_agent_sg"
  vpc_id      = module.shared_vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fivetran_proxy_agent_runners"
  }
}

data "aws_iam_policy_document" "fivetran_proxy_agent_assume_role" {
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

resource "aws_iam_role" "fivetran_proxy_agent_role" {
  name = "fivetran_proxy_agent_role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.fivetran_proxy_agent_assume_role.json
}

resource "aws_iam_role_policy_attachment" "fivetran_proxy_agent_role_ssm" {
  role       = aws_iam_role.fivetran_proxy_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "fivetran_proxy_agent_role_admin" {
  role       = aws_iam_role.fivetran_proxy_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "fivetran_proxy_agent" {
  name = "fivetran_proxy_agent"
  role = aws_iam_role.fivetran_proxy_agent_role.name
}

resource "aws_instance" "fivetran_proxy_agent" {
  ami                    = "ami-037774efca2da0726"
  instance_type          = "m7i.xlarge"
  iam_instance_profile   = aws_iam_instance_profile.fivetran_proxy_agent.name
  subnet_id              = element(module.shared_vpc.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.fivetran_proxy_agent.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "fivetran_proxy_agent"
  }
}

module "fivetran_artifacts" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//s3?ref=v1.3.1"
  providers = {
    aws            = aws
  }
  bucket_name = "120water-fivetran-artifacts-${var.environment_name}"
  canned_acl = "private"
}
