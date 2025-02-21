module "pg_aurora_serverless" {
  source = "./modules/pgsql_aurora"

  db_name       = "postgresql-${var.environment_name}"
  db_subnet_ids = module.shared_vpc.private_subnets
  db_allowed_sgs = [
    { security_group_id = module.vpn.security_group_id, description = "VPN" },
    { security_group_id = data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id, description = "EKS" },
    { security_group_id = module.gitlab.gitlab_runner_security_group_id, description = "GitLab Runners" },
    { security_group_id = aws_security_group.fivetran_proxy_agent.id, description = "FiveTran Proxy" },
    { security_group_id = module.rds_access_sg.id, description = "Lambda RDS Access" }
  ]
  glue_security_group = aws_security_group.glue_connector_security_group.id
}
