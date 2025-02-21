variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}