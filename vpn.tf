module "vpn" {
  source = "./modules/vpn"

  environment_name       = var.environment_name
  subnet_id              = module.shared_vpc.public_subnets[1] # Need a subnet with t4g instances
  private_network_prefix = var.vpn_private_network_prefix
  peers                  = var.vpn_peers
}