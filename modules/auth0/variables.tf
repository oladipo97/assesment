variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
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

variable "snowflake_s3_bucket" {
  type = string
}

variable "sns_audit_topic_arn" {
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
