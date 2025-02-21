module "rds_proxy" {
  source  = "terraform-aws-modules/rds-proxy/aws"
  version = "3.0.0"

  create = true

  name                   = var.name
  iam_role_name         = "${var.name}-role"
  vpc_subnet_ids        = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.proxy.id]

  endpoints = {
    read_write = {
      name                   = "${var.name}-endpoint"
      vpc_subnet_ids        = var.subnet_ids
      vpc_security_group_ids = [aws_security_group.proxy.id]
      target_role           = "READ_WRITE"
    }
  }

  auth = {
    iam_auth    = var.iam_auth
    secret_arn  = var.secret_arn
  }

  engine_family         = var.engine_family
  idle_client_timeout   = var.idle_client_timeout
  debug_logging         = var.debug_logging
  require_tls           = true
}

# Security Group
resource "aws_security_group" "proxy" {
  name        = "${var.name}-proxy-sg"
  description = "Security group for RDS Proxy"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidrs
    content {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-proxy"
  }
}
