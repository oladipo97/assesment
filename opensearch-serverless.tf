module "opensearch" {
  source = "./modules/opensearch_serverless"

  name                 = var.opensearch_name
  subnet_ids           = module.shared_vpc.private_subnets
  description          = var.description
  vpc_id               = module.shared_vpc.vpc_id
  security_group_ids   = module.opensearch_sg.security_group_ids
  policy               = var.policy
  retention_days       = var.retention_days

  depends_on = [
    module.shared_vpc,
    module.opensearch_sg,
  ]
}