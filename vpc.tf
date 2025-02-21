module "admin_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "admin"
  cidr = var.admin_vpc_cidr

  azs             = var.admin_vpc_azs
  private_subnets = var.admin_private_subnet_cidrs
  public_subnets  = var.admin_public_subnet_cidrs

  enable_nat_gateway     = var.admin_enable_nat_gateway
  single_nat_gateway     = var.admin_single_nat_gateway
  one_nat_gateway_per_az = var.admin_one_nat_gateway_per_az

  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch = true
  manage_default_security_group = false
  manage_default_route_table = false
  manage_default_network_acl = false
  
  tags = var.tags
}

module "shared_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "shared"
  cidr = var.shared_vpc_cidr

  azs             = var.shared_vpc_azs
  private_subnets = var.shared_private_subnet_cidrs
  public_subnets  = var.shared_public_subnet_cidrs

  enable_nat_gateway     = var.shared_enable_nat_gateway
  single_nat_gateway     = var.shared_single_nat_gateway
  one_nat_gateway_per_az = var.shared_one_nat_gateway_per_az

  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch = true
  manage_default_security_group = false
  manage_default_route_table = false
  manage_default_network_acl = false

  tags = var.tags
}

data "aws_vpc" "ptd_vpc" {
  id = var.ptd_vpc_id
}

module "admin_shared_peering" {
  source           = "cloudposse/vpc-peering/aws"
  version          = "1.0.0"
  name             = "admin_to_shared"
  requestor_vpc_id = module.admin_vpc.vpc_id
  acceptor_vpc_id  = module.shared_vpc.vpc_id
  tags             = var.tags
}

module "shared_ptd_peering" {
  source           = "cloudposse/vpc-peering/aws"
  version          = "1.0.0"
  name             = "shared_to_ptd"
  requestor_vpc_id = module.shared_vpc.vpc_id
  acceptor_vpc_id  = data.aws_vpc.ptd_vpc.id
  tags             = var.tags
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.5.2"
  vpc_id = module.shared_vpc.vpc_id
  create_security_group      = true
  security_group_name_prefix = "${module.shared_vpc.name}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.shared_vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service              = "s3"
      service_type         = "Gateway"
      route_table_ids = module.shared_vpc.private_route_table_ids
      tags = { Name = "s3-vpc-endpoint" }
    }
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = module.shared_vpc.private_route_table_ids
      tags            = { Name = "dynamodb-vpc-endpoint" }
    }
  }
}





