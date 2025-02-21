variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "security_groups" {
  description = "List of security group configurations"
  type = list(object({
    name        = string
    description = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
  }))
}
