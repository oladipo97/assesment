variable "sg_name" {
  description = "Security Group giving access to RDS"
  type        = string
  default     = "Lambda RDS Access SG"
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security Group providing access to RDS"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules (port, protocol, and allowed CIDR)"
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "tags" {
  description = "Tags to assign to the security group"
  type        = map(string)
  default     = {}
}
