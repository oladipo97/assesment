resource "aws_security_group" "vpn" {
  name        = "vpn-${var.environment_name}"
  description = "VPN"
  vpc_id      = data.aws_subnet.subnet.vpc_id

  ingress {
    description = "Wireguard"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-${var.environment_name}"
  }
}

resource "aws_instance" "vpn" {
  ami                    = var.ami
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.vpn.name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.vpn.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "vpn-${var.environment_name}"
  }
}

resource "aws_eip" "vpn" {
  instance = aws_instance.vpn.id
  domain   = "vpc"
}
