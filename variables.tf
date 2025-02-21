variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cdn_domain_name" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "create_rds" {
  description = "Create shared MSSQL RDS instance?"
  type        = bool
  default     = false
}

variable "mssql_allowed_ips" {
  description = "List of allowed IPs and descriptions for MSSQL access"
  type = list(object({
    cidr        = string
    description = string
  }))
  default = []
}

variable "mssql_multi_az" {
  default = false
  type    = bool
}

variable "mssql_instance_type" {
  default = "db.m6i.xlarge"
  type = string
}

variable "vpn_private_network_prefix" {
  type = string
}

variable "vpn_peers" {
  description = "Config for VPN peers/clients"
  type = list(object({
    comment       = string
    public_key    = string
    last_ip_octet = number
  }))
}

################

variable "admin_vpc_cidr" {
  type = string
}

variable "admin_vpc_azs" {
  type = list(string)
}

variable "admin_private_subnet_cidrs" {
  type = list(string)
}

variable "admin_public_subnet_cidrs" {
  type = list(string)
}

variable "admin_enable_nat_gateway" {
  type = bool
}

variable "admin_single_nat_gateway" {
  type = bool
}

variable "admin_one_nat_gateway_per_az" {
  type = bool
}

################

variable "shared_vpc_cidr" {
  type = string
}

variable "shared_vpc_azs" {
  type = list(string)
}

variable "shared_private_subnet_cidrs" {
  type = list(string)
}

variable "shared_public_subnet_cidrs" {
  type = list(string)
}

variable "shared_enable_nat_gateway" {
  type = bool
}

variable "shared_single_nat_gateway" {
  type = bool
}

variable "shared_one_nat_gateway_per_az" {
  type = bool
}

################

variable "traefik_hostnames" {
  type = list(string)
}

variable "traefik_replicas" {
  type    = number
  default = 1
}

################

variable "developer_role_mode" {
  type        = string
  description = "Used to decide which permissions will be given to the developer role"
}

################

variable "datadog_aws_external_id" {
  type        = string
  description = "External ID string used in the DataDog AWS integration's IAM role"
}

variable "geoserver_desired_capacity" {
  type    = number
  default = 1
}

variable "geoserver_instance_type" {
  type = string
}

variable "batch_desired_capacity" {
  type    = number
  default = 1
}

variable "batch_instance_type" {
  type = string
}

variable "elasticache_nodes" {
  type    = number
  default = 0
}

variable "elasticache_node_type" {
  type = string
}

variable "elasticache_multi_az" {
  type    = bool
  default = false
}

variable "auth0_tenant_domain" {
  type = string
}

variable "auth0_client_id" {
  type = string
}

variable "auth0_client_secret" {
  type = string
}

variable "snowflake_platform_s3_bucket" {
  type = string
}

variable "state_dashboard_hostnames" {
  type = list(string)
}

variable "hydra_hostnames" {
  type = list(string)
}

variable "commit_sha" {
  description = "The git commit SHA, used to pick artifacts and set deployment info"
  type        = string
}

variable "ptd_vpc_id" {
  type = string
}

variable "opensearch_security_groups" {
  description = "List of security group configurations for OpenSearch"
  type = list(object({
    name        = string
    description = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
  }))
}

variable "opensearch_name" {
  description = "OpenSearch Serverless collection name"
  type        = string
}

variable "description" {
  description = "Optional description of the security configuration"
  type        = string
  default     = "OpenSearch Serverless Security Config"
}

variable "policy" {
  description = "JSON document describing the lifecycle policy"
  type        = map(any)
}

variable "retention_days" {
  description = "Number of days to retain data"
  type        = number
  default     = 30
}

variable "rds_proxy_name" {
  description = "Name of the RDS Proxy"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the RDS Proxy should be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS Proxy"
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access the RDS Proxy"
  type        = list(string)
}

variable "secret_arn" {
  description = "AWS Secrets Manager ARN for database credentials"
  type        = string
}

variable "iam_auth" {
  description = "Enable IAM authentication"
  type        = string
  default     = "DISABLED"
}

variable "engine_family" {
  description = "Engine family for the RDS Proxy (MYSQL, POSTGRESQL, or SQLSERVER)"
  type        = string
  default     = "SQLSERVER"
}

variable "idle_client_timeout" {
  description = "The number of seconds a connection is allowed to be idle before being closed"
  type        = number
  default     = 1800
}

variable "debug_logging" {
  description = "Enable debug logging for RDS Proxy"
  type        = bool
  default     = true
}

variable "max_connections_percent" {
  description = "The maximum percentage of connections to the database"
  type        = number
  default     = 90
}

variable "max_idle_connections_percent" {
  description = "The maximum percentage of idle connections"
  type        = number
  default     = 50
}

variable "connection_borrow_timeout" {
  description = "Connection borrow timeout in seconds"
  type        = number
  default     = 120
}
