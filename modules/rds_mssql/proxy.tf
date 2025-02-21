resource "aws_security_group" "proxy" {
  name        = "${var.db_name}-proxy"
  description = "RDS reverse proxy"
  vpc_id      = data.aws_subnet.subnet.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      description = ingress.value["description"]
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      cidr_blocks = [ingress.value["cidr"]]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-proxy"
  }
}

resource "aws_instance" "proxy" {
  ami                    = var.proxy_ami
  instance_type          = var.proxy_instance_type
  iam_instance_profile   = aws_iam_instance_profile.proxy.name
  subnet_id              = var.proxy_subnet_id
  vpc_security_group_ids = [aws_security_group.proxy.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.db_name}-proxy"
  }
}

resource "aws_eip" "proxy" {
  instance = aws_instance.proxy.id
  domain = "vpc"
}

# TODO - DNS entry for EIP

resource "aws_iam_instance_profile" "proxy" {
  name = "${var.db_name}-proxy"
  role = aws_iam_role.proxy.name
}

resource "aws_iam_role" "proxy" {
  name = "${var.db_name}-proxy"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.proxy_assume_role.json
}

data "aws_iam_policy_document" "proxy_assume_role" {
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
  role       = aws_iam_role.proxy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
