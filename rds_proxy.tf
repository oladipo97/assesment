module "rds_proxy" {
  count = var.create_rds ? 1 : 0
  source = "./modules/rds_proxy"
  
  name   = var.rds_proxy_name
  vpc_id = module.shared_vpc.vpc_id
  subnet_ids = module.shared_vpc.private_subnets
  allowed_cidrs = [for ip in local.mssql_allowed_ips : ip.cidr]
  
  secret_arn = module.envirio_db[0].db_instance_master_user_secret_arn
  rds_instance_id = module.envirio_db[0].db_instance_id
  
  iam_auth = var.iam_auth
  engine_family = var.engine_family
  idle_client_timeout = var.idle_client_timeout
  debug_logging = var.debug_logging
  max_connections_percent = var.max_connections_percent
  max_idle_connections_percent = var.max_idle_connections_percent
  connection_borrow_timeout = var.connection_borrow_timeout
}
