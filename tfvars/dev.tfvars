aws_provider_role_arn = "arn:aws:iam::593213874793:role/admin"
environment_name      = "dev"

aws_account_id = "593213874793"
aws_region     = "us-east-2"

admin_vpc_cidr               = "10.50.0.0/16"
admin_vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
admin_private_subnet_cidrs   = ["10.50.0.0/24", "10.50.1.0/24", "10.50.2.0/24"]
admin_public_subnet_cidrs    = ["10.50.128.0/24", "10.50.129.0/24", "10.50.130.0/24"]
admin_enable_nat_gateway     = true
admin_single_nat_gateway     = true
admin_one_nat_gateway_per_az = false

shared_vpc_cidr               = "10.51.0.0/16"
shared_vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
shared_private_subnet_cidrs   = ["10.51.0.0/24", "10.51.1.0/24", "10.51.2.0/24"]
shared_public_subnet_cidrs    = ["10.51.128.0/24", "10.51.129.0/24", "10.51.130.0/24"]
shared_enable_nat_gateway     = true
shared_single_nat_gateway     = true
shared_one_nat_gateway_per_az = false

create_rds = true
mssql_allowed_ips = [
  { cidr = "104.154.83.88/32", description = "GCP Cloud NAT Gateway" },
]
mssql_instance_type = "db.m6i.xlarge"

tags = {
  Environment = "dev"
}

cdn_domain_name = "cdn-dev.120water.com"

vpn_private_network_prefix = "192.168.100"
vpn_peers = [
  { public_key = "WywT5g2tlermLjV4O4hCW3Dcx1Pji7VPssP2ecgffjI=", last_ip_octet = 6, comment = "Mark Preston" },
  { public_key = "l3NpXAGlRAlCjDYFPI65YYjysUsc6UJXltOHVMfanEg=", last_ip_octet = 11, comment = "Josh McBride" },
  { public_key = "WLfhKIXp18G/Exv3w/OOdMoY1rVnKYCEgtHiRwxPHXU=", last_ip_octet = 14, comment = "Meena Gunachandran" },
  { public_key = "A14e9fpNc4CTbd6WpDAXI9ghd+05PvDCI/4pKr9jAnc=", last_ip_octet = 15, comment = "Logan Mulvihill" },
  { public_key = "iFN+TVEIF8+/npp+DW+TfqO4k8QaXmmsdY8q3+TepC8=", last_ip_octet = 17, comment = "David Sutton" },
  { public_key = "ZifoMBwT7C16WrwFct9px17Z/F/3wB7uighdYdunlkU=", last_ip_octet = 18, comment = "James Conant" },
  { public_key = "GH6jw2nuuJwR3CM2B3/fl6qeANcYy3mgfYa1RmYiAz0=", last_ip_octet = 20, comment = "JohnNesha Graves" },
  { public_key = "S9tab6dcgA6Ae9iWps5rOKbUiiFxwJ+Gjmdl85r7pR0=", last_ip_octet = 21, comment = "Sam Kane" },
  { public_key = "qL00KFqYZn+V5PWGq98q7dUVaJ4KcBdy0edatHHwBlw=", last_ip_octet = 24, comment = "Kalob Porter" },
  { public_key = "vLWYAGQLJkI5d9hRbvFivRPP1Jc/6spWhEzPtIvNmCU=", last_ip_octet = 25, comment = "Kyle Thompson" },
  { public_key = "TP0tYLlf4KpCkBMtG3yR5mHHfOP8wWJAChhYDHxLtGo=", last_ip_octet = 26, comment = "Grant Short" },
  { public_key = "JQt/yycF1qFwQgFTbVW3Ddcr0cn/xF5/6+sdo890nSA=", last_ip_octet = 28, comment = "Rob McLaughlin" },
  { public_key = "RpemGhQxL8ygHphP5lfK25clVLDczAYcgxTRDRuqAhs=", last_ip_octet = 29, comment = "John Lawrence" },
  { public_key = "uWXa90NLbJ7nAGUwjifevxFRukwKkSeAL9e9z36QrDA=", last_ip_octet = 30, comment = "Chris Alexeev" },
  { public_key = "Dyhe/Y+8nfYvgZovXwpaXZa782miB8WDDg7DYaEP4UI=", last_ip_octet = 31, comment = "Parker Lawrence" },
  { public_key = "snZvxCmiNMqVC+G6UPgoGDUSGWyiQ23ReYrc0PqEbnc=", last_ip_octet = 32, comment = "Chris Russo" },
  { public_key = "cZdSFO/AblJ6pNqPuhUobNzGAJ//hBHairPtfPVcumY=", last_ip_octet = 33, comment = "Ellie Leppert" },
  { public_key = "6ZC99B9tHHLL4C4lonqXgT9rtlbcym0JkhY96cq8vi4=", last_ip_octet = 34, comment = "Adewale Tokosi" },
  { public_key = "qe/m2Dk9LD33Bi+LjepXMDgqDA1E90QGs3JKU1c/9zs=", last_ip_octet = 35, comment = "Daniel Buergler" },
  { public_key = "KZgKCAcz8H5HSkmDwk0ZgjMmURg1aDxt0VvKWMbNqCE=", last_ip_octet = 36, comment = "Alan Spott" },
  { public_key = "h2XmFYx0KWn/o7KJWZhMNyNOD0LQeHeqpUNUTD3UIGg=", last_ip_octet = 37, comment = "Kevin Clarke" },
  { public_key = "F5KgUQxR87QwzPj3SLCZJirVh3WPboqBjQsZ1hzScGk=", last_ip_octet = 38, comment = "Martin Teufel" }
]

traefik_hostnames = ["api-dev.120water.com"]

developer_role_mode = "readwrite"

datadog_aws_external_id = "defeca4b100946d88f5aaaadaa63e60b"

geoserver_desired_capacity = 1
geoserver_instance_type    = "t3a.large"

batch_desired_capacity = 2
batch_instance_type    = "c6g.xlarge"

elasticache_nodes     = 1
elasticache_node_type = "cache.t4g.small"
elasticache_multi_az  = false

snowflake_platform_s3_bucket = "arn:aws:s3:::120water-dev-snowflake-platform"

state_dashboard_hostnames = ["https://state-dashboard-dev.120water.com", "https://state-dashboard-dev.120wateraudit.com","https://state-dashboard-local.120wateraudit.com:3002", "http://localhost:3002", "http://localhost:3000"]
hydra_hostnames = ["https://insights-dev.120water.com", "https://insights-dev.120wateraudit.com","https://insights-local.120wateraudit.com:3003", "http://localhost:3003"]

ptd_vpc_id = "vpc-05bf4cf9c15bafea4"

opensearch_security_groups = [
  {
    name        = "dev-opensearch-sg"
    description = "Security group for OpenSearch in dev environment"
    ingress_rules = [
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS traffic"
      },
      {
        from_port   = 9200
        to_port     = 9200
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow OpenSearch HTTP traffic"
      }
    ]
  }
]

opensearch_name = "opensearch"

description = "OpenSearch Serverless Config for dev environment"

#OpenSearch Lifecycle Policy
policy = {
  Rules = [
      {
        ResourceType = "index",
        Resource = ["index/users/*"],
        MinIndexRetention = "90d"
      },
      {
        ResourceType = "index",
        Resource = ["index/accounts/*"],
        NoMinIndexRetention = true
      }
    ]
}

retention_days = 30

# RDS Proxy Configuration
rds_proxy_name = "envirio-dev-proxy"
iam_auth = "DISABLED"
engine_family = "SQLSERVER"
idle_client_timeout = 1800
debug_logging = true
max_connections_percent = 90
max_idle_connections_percent = 50
connection_borrow_timeout = 120

# Note: vpc_id and subnet_ids can be derived from existing VPC configurations
# allowed_cidrs can use the same IPs as mssql_allowed_ips