variable "db_name" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_allowed_sgs" {
  type = list(object({
    security_group_id = string
    description       = string
  }))
  default = []
}

variable "glue_security_group" {
  type    = string
}
