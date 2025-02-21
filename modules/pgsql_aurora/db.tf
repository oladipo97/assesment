resource "aws_security_group" "db" {
  name        = var.db_name
  description = "${var.db_name} RDS instance"
  vpc_id      = data.aws_subnet.subnet.vpc_id

  dynamic "ingress" {
    for_each = var.db_allowed_sgs
    content {
      description     = ingress.value["description"]
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value["security_group_id"]]
    }
  }

  ingress {
    description = "Glue security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [var.glue_security_group]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.db_name
  }
}

resource "aws_db_parameter_group" "pgsql_aurora_16" {
  name        = "${var.db_name}-aurora-db-postgres16-parameter-group"
  family      = "aurora-postgresql16"
  description = "${var.db_name}-aurora-db-postgres16-parameter-group"

  parameter {
    name  = "pg_stat_statements.track"
    value = "ALL"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "pg_stat_statements.max"
    value = "10000"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "pg_stat_statements.track_utility"
    value = "0"
    apply_method = "pending-reboot"
  }
}

resource "aws_rds_cluster_parameter_group" "pgsql_aurora_16" {
  name        = "${var.db_name}-aurora-postgres16-cluster-parameter-group"
  family      = "aurora-postgresql16"
  description = "${var.db_name}-aurora-postgres16-cluster-parameter-group"

  parameter {
    name  = "pg_stat_statements.track"
    value = "ALL"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "pg_stat_statements.max"
    value = "10000"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "pg_stat_statements.track_utility"
    value = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "wal_sender_timeout"
    value = "0"
    apply_method = "pending-reboot"
  }
}

module "db" {
  source  = "registry.terraform.io/terraform-aws-modules/rds-aurora/aws"
  version = "7.7.1"

  name                   = var.db_name
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned" # Unexpected, but correct
  engine_version         = "16.3"
  storage_encrypted      = true
  random_password_length = 64
  subnets                = var.db_subnet_ids
  create_security_group  = false
  vpc_security_group_ids = [aws_security_group.db.id]
  allow_major_version_upgrade = true
  
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  monitoring_interval                   = 60
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  apply_immediately      = true
  skip_final_snapshot    = false
  create_random_password = true

  master_username = "root"

  db_parameter_group_name         = aws_db_parameter_group.pgsql_aurora_16.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.pgsql_aurora_16.id
  db_cluster_db_instance_parameter_group_name = aws_db_parameter_group.pgsql_aurora_16.name

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 32
  }

  instance_class = "db.serverless"
  instances = {
    1 = {}
    2 = {}
  }
}
