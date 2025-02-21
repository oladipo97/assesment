resource "aws_security_group" "db" {
  name        = var.db_name
  description = "${var.db_name} RDS instance"
  vpc_id      = data.aws_subnet.subnet.vpc_id

  ingress {
    description     = "Proxy"
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy.id]
  }

  ingress {
    description = "Windows Server Failover Cluster"
    from_port   = 3343
    to_port     = 3343
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Windows Server Failover Cluster"
    from_port   = 3343
    to_port     = 3343
    protocol    = "udp"
    self        = true
  }

  dynamic "ingress" {
    for_each = var.db_allowed_sgs
    content {
      description     = ingress.value["description"]
      from_port       = 1433
      to_port         = 1433
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

resource "aws_db_parameter_group" "sqlserver_16_parameter_group" {
  name        = "${var.db_name}-sqlserver-16-db-parameter-group"
  family      = "sqlserver-se-16.0"
  description = "${var.db_name}-sqlserver-16-db-parameter-group"

  parameter { 
    apply_method = "immediate"
    name         = "cost threshold for parallelism"
    value        = "50"
  }

  parameter {
    apply_method = "immediate"
    name         = "max degree of parallelism"
    value        = "4"
  }
}

module "db" {
  source  = "registry.terraform.io/terraform-aws-modules/rds/aws"
  version = "5.9.0"

  identifier = var.db_name

  engine               = "sqlserver-se"
  engine_version       = "16.00.4140.3.v1"
  family               = "sqlserver-se-16.0" # DB parameter group
  major_engine_version = "16.00"             # DB option group
  instance_class       = var.db_instance_type
  apply_immediately    = true
  allow_major_version_upgrade = true

  allocated_storage     = 200
  max_allocated_storage = 1000
  storage_encrypted     = true
  storage_type          = "gp3"
  create_db_parameter_group = false
  parameter_group_name = aws_db_parameter_group.sqlserver_16_parameter_group.name

  db_name                = null # No database will be created initially
  username               = "root"
  create_random_password = true
  random_password_length = 64
  port                   = 1433

  multi_az               = var.db_multi_az
  subnet_ids             = var.db_subnet_ids
  vpc_security_group_ids = [aws_security_group.db.id]
  create_db_subnet_group = true

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["agent", "error"]

  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "${var.db_name}-rds-monitoring-role"
  
  ca_cert_identifier = "rds-ca-rsa2048-g1"
  license_model      = "license-included"
  timezone           = "GMT Standard Time"
  character_set_name = "Latin1_General_CI_AS"

  timeouts = {
    "create" = "120m",
    "delete" = "60m",
    "update" = "120m"
  }
}



