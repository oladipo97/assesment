locals {
  global_mssql_allowed_ips = [
    { cidr = "35.185.9.209/32", description = "GitLab DB Migrations" },
  ]

  mssql_allowed_ips = concat(local.global_mssql_allowed_ips, var.mssql_allowed_ips)
}