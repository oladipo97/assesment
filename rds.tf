module "envirio_db" {
  count = var.create_rds ? 1 : 0

  source = "./modules/rds_mssql"

  db_name       = "envirio-${var.environment_name}"
  db_multi_az   = var.mssql_multi_az
  db_instance_type = var.mssql_instance_type
  db_subnet_ids = module.shared_vpc.private_subnets
  allowed_ips   = local.mssql_allowed_ips # Note: using local, not var
  db_allowed_sgs = [
    { security_group_id = module.vpn.security_group_id, description = "VPN" },
    { security_group_id = data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id, description = "EKS" },
    { security_group_id = module.gitlab.gitlab_runner_security_group_id, description = "GitLab Runners" },
    { security_group_id = aws_security_group.fivetran_proxy_agent.id, description = "FiveTran Proxy" },
    { security_group_id = module.rds_access_sg.id, description = "Lambda RDS Access" }
  ]
  glue_security_group = aws_security_group.glue_connector_security_group.id

  proxy_subnet_id = module.shared_vpc.public_subnets[1] # Need a subnet with t4g instances
}
