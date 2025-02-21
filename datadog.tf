module "datadog" {
  source      = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//datadog?ref=v1.1.0"
  external_id = var.datadog_aws_external_id
}