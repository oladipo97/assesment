module "rds_access_sg" {
  source = "./modules/rds_sg"
  sg_name = "rds-access"
  ingress_rules = [
    { port = 5432, cidr_blocks = [var.shared_vpc_cidr], protocol = "tcp" },
    { port = 1433, cidr_blocks = [var.shared_vpc_cidr], protocol = "tcp" },
  ]
  sg_description = "Security Group providing access to RDS"
  vpc_id = module.shared_vpc.vpc_id
}

module "opensearch_sg" {
  source          = "./modules/opensearch_sg"
  vpc_id          = module.shared_vpc.vpc_id
  security_groups = var.opensearch_security_groups
}