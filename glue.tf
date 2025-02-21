data "aws_secretsmanager_secret" "common_secrets" {
  name = "/secret/common"
}

data "aws_secretsmanager_secret_version" "common_secrets_current" {
  secret_id = data.aws_secretsmanager_secret.common_secrets.id
}

locals {
  common_secret = jsondecode(data.aws_secretsmanager_secret_version.common_secrets_current.secret_string)
}

resource "aws_s3_bucket" "glue_job_artifacts" {
  bucket = "120water-glue-job-artifacts-${var.environment_name}"
}

resource "aws_s3_bucket_acl" "glue_job_artifacts_acl" {
  bucket = aws_s3_bucket.glue_job_artifacts.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.glue_job_artifacts.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "platform_glue_job_artifacts_public_access" {
  bucket = aws_s3_bucket.glue_job_artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "glue_role" {
  name = "AWSGlueServiceRole-120Water"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/service-role/AwsGlueSessionUserRestrictedNotebookServiceRole",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  inline_policy {
    name = "Decrypt"
    policy = jsonencode({
      "Version":"2012-10-17",
      "Statement":[
        {
          "Effect":"Allow",
          "Action":[
            "kms:Decrypt"
          ],
          "Resource": "*"
        }
      ]
    })
  }
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "glue.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_glue_catalog_database" "mssql_catalog_database" {
  name = "mssql_catalog_database"
}

resource "aws_glue_catalog_database" "postgres_catalog_database" {
  name = "postgres_catalog_database"
}

resource "aws_glue_catalog_database" "s3_catalog_database" {
  name = "s3_catalog_database"
}

resource "aws_glue_catalog_database" "event_ledger_catalog_database" {
  name = "event_ledger_catalog_database"
}

resource "aws_security_group" "glue_connector_security_group" {
  name = "glue_connector_security_group"
  vpc_id = module.shared_vpc.vpc_id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_glue_connection" "mssql" {
  name = "mssql"
  connection_type = "JDBC"
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:sqlserver://${local.common_secret["envirio-host"]}:1433;databaseName=${local.common_secret["envirio-database"]}"
    USERNAME = local.common_secret["envirio-username"]
    PASSWORD = local.common_secret["envirio-password"]
  }
  physical_connection_requirements {
    availability_zone = module.shared_vpc.azs[0]
    subnet_id = module.shared_vpc.private_subnets[0]
    security_group_id_list = [
      aws_security_group.glue_connector_security_group.id
    ]
  }
  depends_on = [
    aws_security_group.glue_connector_security_group
  ]
}

resource "aws_glue_connection" "snowflake" {
  name = "snowflake"
  connection_type = "MARKETPLACE"
  connection_properties = {
    CONNECTOR_TYPE = "MARKETPLACE"
    CONNECTOR_URL = "https://709825985650.dkr.ecr.us-east-1.amazonaws.com/amazon-web-services/glue/snowflake:2.9.1-glue3.0-2"
    CONNECTOR_CLASS_NAME = "net.snowflake.spark.snowflake"
    SECRET_ID = "/secret/snowflake/credentials"
  }
  physical_connection_requirements {
    availability_zone = module.shared_vpc.azs[0]
    subnet_id = module.shared_vpc.private_subnets[0]
    security_group_id_list = [
      aws_security_group.glue_connector_security_group.id
    ]
  }
  depends_on = [
    aws_security_group.glue_connector_security_group
  ]
}

resource "aws_glue_connection" "postgres_state_submission" {
  name = "postgres_state_submission"
  connection_type = "JDBC"
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:postgresql://${local.common_secret["postgres-ro-host"]}:${local.common_secret["postgres-port"]}/${local.common_secret["state-submission-database"]}"
    USERNAME = local.common_secret["etl-user"]
    PASSWORD = local.common_secret["etl-password"]
  }
  physical_connection_requirements {
    availability_zone = module.shared_vpc.azs[0]
    subnet_id = module.shared_vpc.private_subnets[0]
    security_group_id_list = [
      aws_security_group.glue_connector_security_group.id
    ]
  }
  depends_on = [
    aws_security_group.glue_connector_security_group
  ]
}

resource "aws_glue_connection" "postgres_geodata" {
  name = "postgres_geodata"
  connection_type = "JDBC"
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:postgresql://${local.common_secret["postgres-host"]}:${local.common_secret["postgres-port"]}/geodata"
    USERNAME = local.common_secret["etl-user"]
    PASSWORD = local.common_secret["etl-password"]
  }
  physical_connection_requirements {
    availability_zone = module.shared_vpc.azs[0]
    subnet_id = module.shared_vpc.private_subnets[0]
    security_group_id_list = [
      aws_security_group.glue_connector_security_group.id
    ]
  }
  depends_on = [
    aws_security_group.glue_connector_security_group
  ]
}

resource "aws_glue_crawler" "mssql_crawler" {
  database_name = aws_glue_catalog_database.mssql_catalog_database.name
  name          = "mssql_crawler"
  role          = aws_iam_role.glue_role.arn
  jdbc_target {
    connection_name = aws_glue_connection.mssql.name
    path            = "${local.common_secret["envirio-database"]}/dbo/%"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_glue_crawler" "postgres_state_submission_crawler" {
  database_name = aws_glue_catalog_database.postgres_catalog_database.name
  name          = "state_submission_crawler"
  role          = aws_iam_role.glue_role.arn
  jdbc_target {
    connection_name = aws_glue_connection.postgres_state_submission.name
    path            = "${local.common_secret["state-submission-database"]}/${local.common_secret["state-submission-schema"]}/%"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_glue_crawler" "postgres_geodata_crawler" {
  database_name = aws_glue_catalog_database.postgres_catalog_database.name
  name          = "geodata_crawler"
  role          = aws_iam_role.glue_role.arn
  jdbc_target {
    connection_name = aws_glue_connection.postgres_geodata.name
    path            = "geodata/public/%"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_glue_crawler" "event_ledger_crawler" {
  database_name = aws_glue_catalog_database.event_ledger_catalog_database.name
  name          = "event_ledger_crawler"
  role          = aws_iam_role.glue_role.arn
  s3_target {
    path = "s3://120water-event-ledger-${var.environment_name}/logs"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_object" "snowflake_jdbc" {
  bucket = aws_s3_bucket.glue_job_artifacts.id
  key    = "gluejars/snowflake-jdbc.jar"
  source = "./glue/jars/snowflake-jdbc-3.13.26.jar"
  source_hash = filemd5("./glue/jars/snowflake-jdbc-3.13.26.jar")
}

resource "aws_s3_object" "postgres_jdbc" {
  bucket = aws_s3_bucket.glue_job_artifacts.id
  key    = "gluejars/postgresql.jar"
  source = "./glue/jars/postgresql-42.5.2.jar"
  source_hash = filemd5("./glue/jars/postgresql-42.5.2.jar")
}

resource "aws_s3_object" "spark_snowflake" {
  bucket = aws_s3_bucket.glue_job_artifacts.id
  key    = "gluejars/spark-snowflake-spark_3.1.jar"
  source = "./glue/jars/spark-snowflake_2.12-2.11.1-spark_3.1.jar"
  source_hash = filemd5("./glue/jars/spark-snowflake_2.12-2.11.1-spark_3.1.jar")
}

resource "aws_s3_object" "glue_shared" {
  bucket = aws_s3_bucket.glue_job_artifacts.id
  key    = "libraries/glue_shared.py"
  source = "./glue/libraries/glue_shared.py"
  source_hash = filemd5("./glue/libraries/glue_shared.py")
}
