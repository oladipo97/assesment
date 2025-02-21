variable "db_name" {
  type = string
}

variable "db_multi_az" {
  type = bool
}

variable "db_instance_type" {
  default = "db.m6i.xlarge"
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "proxy_ami" {
  default = "ami-016358f52b91190bc"
  type    = string
}

variable "proxy_instance_type" {
  default = "t4g.micro"
  type    = string
}

variable "proxy_subnet_id" {
  type = string
}

variable "allowed_ips" {
  type = list(object({
    cidr        = string
    description = string
  }))
  default = []
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