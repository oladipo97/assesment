locals {
  vpn_config = templatefile("${path.module}/wg0.conf.template", {
    private_network_prefix = var.private_network_prefix
    private_key            = data.aws_ssm_parameter.private_key.value
    peers                  = var.peers
  })
}