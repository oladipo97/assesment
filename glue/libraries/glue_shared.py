from py4j.java_gateway import java_import
import boto3 as boto3
import json


def init_snowflake(database, schema, glue_context):
    java_import(glue_context.spark_session._jvm, "net.snowflake.spark.snowflake")
    glue_context.spark_session._jvm.net.snowflake.spark.snowflake.SnowflakeConnectorUtils.enablePushdownSession(glue_context.spark_session._jvm.org.apache.spark.sql.SparkSession.builder().getOrCreate())
    secrets_client = boto3.client("secretsmanager")
    response = secrets_client.get_secret_value(SecretId="/secret/snowflake/credentials")
    snowflake_secrets = json.loads(response['SecretString'])
    options = {
        "sfURL": snowflake_secrets['sfUrl'],
        "sfUser": snowflake_secrets['sfUser'],
        "sfPassword": snowflake_secrets['sfPassword'],
        "sfDatabase": database,
        "sfSchema": schema,
        "sfWarehouse": 'ETL_WH',
        "sfRole": 'ETL',
        "column_mismatch_behavior": 'ignore',
        "truncate_table": "ON",
        "usestagingtable": "OFF"
    }
    return options


def init_snowflake_append(database, schema, glue_context):
    java_import(glue_context.spark_session._jvm, "net.snowflake.spark.snowflake")
    glue_context.spark_session._jvm.net.snowflake.spark.snowflake.SnowflakeConnectorUtils.enablePushdownSession(glue_context.spark_session._jvm.org.apache.spark.sql.SparkSession.builder().getOrCreate())
    secrets_client = boto3.client("secretsmanager")
    response = secrets_client.get_secret_value(SecretId="/secret/snowflake/credentials")
    snowflake_secrets = json.loads(response['SecretString'])
    options = {
        "sfURL": snowflake_secrets['sfUrl'],
        "sfUser": snowflake_secrets['sfUser'],
        "sfPassword": snowflake_secrets['sfPassword'],
        "sfDatabase": database,
        "sfSchema": schema,
        "sfWarehouse": 'ETL_WH',
        "sfRole": 'ETL',
        "column_mismatch_behavior": 'ignore',
        "column_mapping": 'name'
    }
    return options


def write_snowflake_data(frame, table, mode, sf_options):
    frame.write.format("net.snowflake.spark.snowflake").options(**sf_options).option("dbtable", table).mode(mode).save()


def load_snowflake_table(table, sf_options, glue_context):
    return glue_context.spark_session.read.format("net.snowflake.spark.snowflake").options(**sf_options).option("dbtable", table).load()


def load_mssql_table(table, glue_context):
    return glue_context.create_dynamic_frame.from_catalog(database="mssql_catalog_database",
                                                          table_name=table)