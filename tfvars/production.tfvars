aws_provider_role_arn = "arn:aws:iam::152774149313:role/admin"
environment_name      = "production"

aws_account_id = "152774149313"
aws_region     = "us-east-2"

admin_vpc_cidr               = "10.150.0.0/16"
admin_vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
admin_private_subnet_cidrs   = ["10.150.0.0/24", "10.150.1.0/24", "10.150.2.0/24"]
admin_public_subnet_cidrs    = ["10.150.128.0/24", "10.150.129.0/24", "10.150.130.0/24"]
admin_enable_nat_gateway     = true
admin_single_nat_gateway     = true
admin_one_nat_gateway_per_az = false

shared_vpc_cidr               = "10.151.0.0/16"
shared_vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
shared_private_subnet_cidrs   = ["10.151.0.0/24", "10.151.1.0/24", "10.151.2.0/24"]
shared_public_subnet_cidrs    = ["10.151.128.0/24", "10.151.129.0/24", "10.151.130.0/24"]
shared_enable_nat_gateway     = true
shared_single_nat_gateway     = false
shared_one_nat_gateway_per_az = true

create_rds     = true
mssql_multi_az = true
mssql_allowed_ips = [
  { cidr = "35.222.20.53/32", description = "GCP Cloud NAT Gateway" },
]
mssql_instance_type = "db.m6i.xlarge"

tags = {
  Environment = "production"
}

cdn_domain_name = "cdn.120water.com"

vpn_private_network_prefix = "192.168.110"
vpn_peers = [
  { public_key = "9MeXm3R1UDCiTw3J6HtJoQMo7fxjds5hez2X+OD/aVU=", last_ip_octet = 6, comment = "Mark Preston" },
  { public_key = "93TW+FzyD+bmMVJsZlKErr57Hvi3MELFWObBq3fIKwc=", last_ip_octet = 11, comment = "Josh McBride" },
  { public_key = "UZvJFEeYtUTwl1OWNls986fOeqteaZfYFGB1i1MLjGk=", last_ip_octet = 14, comment = "Meena Gunachandran" },
  { public_key = "Eps4jSwEykQ2CdS3Er+bNmyh4Wc1a6DPV7ssk+MivCg=", last_ip_octet = 15, comment = "Logan Mulvihill" },
  { public_key = "e+8x1QN+NX4cEz7nEJ8bL4leMPangW0ySv6DfNrDpiE=", last_ip_octet = 17, comment = "David Sutton" },
  { public_key = "P5z19qT33RN74jnFwONXtFWERf1MIBrb4Iq0BjITalA=", last_ip_octet = 18, comment = "James Conant" },
  { public_key = "JYq7uLmJQABZHtglRh4JbiHidJrskfOnd/5lcf/gYU8=", last_ip_octet = 20, comment = "JohnNesha Graves" },
  { public_key = "Ax7i5WTQdWaznxBSiTBfr5jiyLOMn6BSLrKlEJAp5y0=", last_ip_octet = 21, comment = "Sam Kane" },
  { public_key = "jhG9GO6liin4L2O/p652FRbNEPOthmk/p0qpLJEndQs=", last_ip_octet = 24, comment = "Kalob Porter" },
  { public_key = "T0NYOpmHn9yFTmmK0cetRmHuw3KaGzz9lmxem9rJlTE=", last_ip_octet = 25, comment = "Kyle Thompson" },
  { public_key = "bsrYNmWb9Vb4/MqJYQaJV4FS9gH4JjSNL7f+Z8fN42c=", last_ip_octet = 26, comment = "Grant Short" },
  { public_key = "REtW7lLfz8dqRAZXIblT3aCl39OucjA6906MMTenvls=", last_ip_octet = 28, comment = "Rob McLaughlin" },
  { public_key = "00gb3Gtd+B9HP6ml2r6KIg0Jl0ziAziiqZ2fb1xbG2k=", last_ip_octet = 29, comment = "John Lawrence" },
  { public_key = "Xe4TjA7NGrY/FdXqfw0y6h7vHfXXsVSdj3mSggsHXys=", last_ip_octet = 30, comment = "Chris Alexeev" },
  { public_key = "9xKrszeJnQSjhH9po9jtx7TAozHwhbgWPx78jmKY0D8=", last_ip_octet = 31, comment = "Parker Lawrence" },
  { public_key = "hQT1MwSJpO4/BARpVsC1OpR/WERfzePT3FfjT8XXa1s=", last_ip_octet = 32, comment = "Chris Russo" },
  { public_key = "gu/mUUqjMEyNSnuduFiMe4b1idZSyd+g6Vf2ue5LUlg=", last_ip_octet = 33, comment = "Ellie Leppert" },
  { public_key = "m/4ijDkbn9tgAfnlU7AXxxPLQNRHr77QfzoR0cYPXR4=", last_ip_octet = 34, comment = "Adewale Tokosi" },
  { public_key = "RZoDHHAk03roIuhkkfxN+ZtHZNTm6tUtM+fscfPOq0s=", last_ip_octet = 35, comment = "Daniel Buergler" },
  { public_key = "q1godrhlIZ0DqSrFZJr8uLFPyKMrj/89wpoMKlz1YXg=", last_ip_octet = 36, comment = "Alan Spott" },
  { public_key = "H2Owf2jYqGqmz1JMkpjdiKQtxYdEU9+AmrTHr+y0kkI=", last_ip_octet = 37, comment = "Kevin Clarke" },
  { public_key = "V4Xt0AAiGgCKGyzVEVQbXqwgjIPHwxlZFLjELnIm2jI=", last_ip_octet = 38, comment = "Martin Teufel" }
]

traefik_hostnames = ["api.120water.com"]
traefik_replicas  = 3

developer_role_mode = "readonly"

datadog_aws_external_id = "e319386086984a79a54bb6ae69c35ec0"

geoserver_desired_capacity = 2
geoserver_instance_type    = "m6i.large"

batch_desired_capacity = 2
batch_instance_type    = "c6g.xlarge"

elasticache_nodes     = 2
elasticache_node_type = "cache.t4g.small"
elasticache_multi_az  = true

snowflake_platform_s3_bucket = "arn:aws:s3:::120water-production-snowflake-platform"

state_dashboard_hostnames = ["https://state-dashboard.120water.com", "https://state-dashboard.120wateraudit.com"]
hydra_hostnames = ["https://insights.120water.com", "https://insights.120wateraudit.com"]

ptd_vpc_id = "vpc-0ca9813d9eecc6195"

opensearch_security_groups = [
  {
    name        = "prod-opensearch-sg"
    description = "Security group for OpenSearch in prod environment"
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

description = "OpenSearch Serverless Config for prod environment"

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