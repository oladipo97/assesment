variable "name" {
  description = "OpenSearch Serverless collection name"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for VPC integration"
  type        = list(string)
}

variable "description" {
  description = "Optional description of the OpenSearch"
  type        = string
  default     = "OpenSearch Serverless"
}

variable "vpc_id" {
  description = "ID of the VPC to integrate with"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for VPC integration"
  type        = list(string)
}

variable "policy" {
  description = "JSON document describing the lifecycle policy"
  type        = map(any)
}

variable "retention_days" {
  description = "Number of days to retain data"
  type        = number
  default     = 30
}
