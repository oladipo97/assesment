variable "name" {
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
  default     = false
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

variable "rds_instance_id" {
  description = "RDS Instance Identifier"
  type        = string
}
