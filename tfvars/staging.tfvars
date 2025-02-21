aws_provider_role_arn = "arn:aws:iam::037746281658:role/admin"
environment_name      = "staging"

aws_account_id = "037746281658"
aws_region     = "us-east-2"

admin_vpc_cidr               = "10.100.0.0/16"
admin_vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
admin_private_subnet_cidrs   = ["10.100.0.0/24", "10.100.1.0/24", "10.100.2.0/24"]
admin_public_subnet_cidrs    = ["10.100.128.0/24", "10.100.129.0/24", "10.100.130.0/24"]
admin_enable_nat_gateway     = true
admin_single_nat_gateway     = true
admin_one_nat_gateway_per_az = false

shared_vpc_cidr               = "10.101.0.0/16"
shared_vpc_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
shared_private_subnet_cidrs   = ["10.101.0.0/24", "10.101.1.0/24", "10.101.2.0/24"]
shared_public_subnet_cidrs    = ["10.101.128.0/24", "10.101.129.0/24", "10.101.130.0/24"]
shared_enable_nat_gateway     = true
shared_single_nat_gateway     = false
shared_one_nat_gateway_per_az = true

create_rds = true
mssql_allowed_ips = [
  { cidr = "35.193.102.229/32", description = "GCP Cloud NAT Gateway" },
]
mssql_instance_type = "db.m6i.xlarge"

tags = {
  Environment = "staging"
}

cdn_domain_name = "cdn-staging.120water.com"

vpn_private_network_prefix = "192.168.105"
vpn_peers = [
  { public_key = "IJHwJrt4vV1jKYNbHXsGc/bA4RWwZ8D5nVp7VVXf0Gw=", last_ip_octet = 6, comment = "Mark Preston" },
  { public_key = "MpKEnbZRUzpABHjMkPQ1VcPz0NtuNQTMlRle/7De5WM=", last_ip_octet = 11, comment = "Josh McBride" },
  { public_key = "Uavoii7o69IjWXQdbCWBBsw06uHKfAv4RE3g4gWJ2Co=", last_ip_octet = 14, comment = "Meena Gunachandran" },
  { public_key = "Fu6MP/0L3c/XsWPh66/ysIZcol8DY9Mrp6cUNN1ynwU=", last_ip_octet = 15, comment = "Logan Mulvihill" },
  { public_key = "Y4wfU+4cjAWQ6BJbxMlG/z8bGhKySG+n9epDhE2/Ago=", last_ip_octet = 17, comment = "David Sutton" },
  { public_key = "WS06tlUXOoVfoSwcqHQJM2Hc2xz9LCL8vwFJ9Yqqzks=", last_ip_octet = 18, comment = "James Conant" },
  { public_key = "wp36TWkJa218/w6pmw9fCqeD1NWawHjYXZuMod3Xc3g=", last_ip_octet = 20, comment = "JohnNesha Graves" },
  { public_key = "3T1Pe2YNXssDCtSu0fNTp5KIDSXI/0zgywas7RUY0l0=", last_ip_octet = 21, comment = "Sam Kane" },
  { public_key = "AN9gH+J30kT5FFfDqTxI0+ewwRVL7k8O8DZMI8wfd3E=", last_ip_octet = 24, comment = "Kalob Porter" },
  { public_key = "08Y7RMrBUFP2/HwfOlhvYnxSrxMPlIAavunjrqvN2wQ=", last_ip_octet = 25, comment = "Kyle Thompson" },
  { public_key = "ArQXjJGBmD0qxZ3gMs46WJosfdvtrXFr5VLBFnYQYl4=", last_ip_octet = 26, comment = "Grant Short" },
  { public_key = "21XiwnoAiFFtvxMOm1Zbj+aJIDccuHO0VvsA+87f0GI=", last_ip_octet = 28, comment = "Rob McLaughlin" },
  { public_key = "HOXJVbvX9eatOz+spRayovPPcIzFfhdLt9hyfzhVeTU=", last_ip_octet = 29, comment = "John Lawrence" },
  { public_key = "Zpkyl2iTTOxSM5Gyn2Bjz/hBslblhJHDXuodt3IMYlk=", last_ip_octet = 30, comment = "Chris Alexeev" },
  { public_key = "3cyv0os+F+2TC7MXg0lPpl/eUAgnuZKsDb6AVME7n1s=", last_ip_octet = 31, comment = "Parker Lawrence" },
  { public_key = "4fK9TsLCintY82jqEWcbqpm2lOo5EyNQ7LT18s0/Skg=", last_ip_octet = 32, comment = "Chris Russo" },
  { public_key = "wRKGNY1qcFmnqwS/HPXbQeqPCHpLn4JOydHHt21IKXU=", last_ip_octet = 33, comment = "Ellie Leppert" },
  { public_key = "UWIXlGddL4R6jxd6OXGdhJjsiXY3hQTLHFtepU4SwWM=", last_ip_octet = 34, comment = "Adewale Tokosi" },
  { public_key = "8AIHaG8HgotyG20/5x2WO+ImeVPqgCZSAtS3XraSUHw=", last_ip_octet = 35, comment = "Daniel Buergler" },
  { public_key = "0vmIFJVF7JNguzsJRFQRg4pCPhi4sh//oCAd9e8tgwo=", last_ip_octet = 36, comment = "Alan Spott" },
  { public_key = "zQ38xmhb8Mez5m3h0YGaSBzom7P6Hlyg2gnyBOEYihA=", last_ip_octet = 37, comment = "Kevin Clarke" },
  { public_key = "xwZsBayd/ngp9g8Ir8saR+yhgvi+4mkocftwjARys1o=", last_ip_octet = 38, comment = "Martin Teufel" }
]

traefik_hostnames = ["api-staging.120water.com"]

developer_role_mode = "readwrite"

datadog_aws_external_id = "644036d1d9df4a3a97a6ba0f9a7a0f4f"

geoserver_desired_capacity = 1
geoserver_instance_type    = "t3a.large"

batch_desired_capacity = 2
batch_instance_type    = "c6g.xlarge"

elasticache_nodes     = 1
elasticache_node_type = "cache.t4g.small"
elasticache_multi_az  = false

snowflake_platform_s3_bucket = "arn:aws:s3:::120water-staging-snowflake-platform"

state_dashboard_hostnames = ["https://state-dashboard-staging.120water.com", "https://state-dashboard-staging.120wateraudit.com"]
hydra_hostnames = ["https://insights-staging.120water.com", "https://insights-staging.120wateraudit.com"]

ptd_vpc_id = "vpc-0a5113b7495cfebad"

opensearch_security_groups = [
  {
    name        = "stage-opensearch-sg"
    description = "Security group for OpenSearch in stage environment"
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

description = "OpenSearch Serverless Config for stage environment"

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