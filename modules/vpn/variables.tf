variable "environment_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ami" {
  default = "ami-016358f52b91190bc"
  type    = string
}

variable "instance_type" {
  default = "t4g.micro"
  type    = string
}

variable "private_network_prefix" {
  description = "Prefix for the Wireguard private network. I.e. '192.168.100'"
  type        = string
}

variable "peers" {
  description = "Config for VPN peers/clients"
  type = list(object({
    comment       = string
    public_key    = string
    last_ip_octet = number
  }))
}
