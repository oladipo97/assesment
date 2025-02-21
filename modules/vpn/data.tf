data "aws_subnet" "subnet" {
  id = var.subnet_id
}

data "aws_ssm_parameter" "private_key" {
  name = "/vpn/private_key"
}