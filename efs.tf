resource "aws_security_group" "efs_security_group" {
  name = "efs-security-group"
  description = "efs-security-group"
  vpc_id = module.shared_vpc.vpc_id
  ingress {
    cidr_blocks = var.shared_private_subnet_cidrs
    from_port = 2049
    protocol  = "tcp"
    to_port   = 2049
  }
}

resource "aws_ssm_parameter" "efs_eks_security_group" {
  name  = "/platform/efs/efs_security_group_id"
  type  = "String"
  value = aws_security_group.efs_security_group.id
}