variable "vpc_id" {
  type = string
  validation {
    condition = can(regex("^vpc-", var.vpc_id))
    error_message = "Invalid VPC id!!!"
  }
}

variable "inbound_ports" {
  type = list(object({
    description = string
    from_port = number
    to_port = number
    protocol = string
    cidr_block = list(string)
  }))
}

variable "sg_server_name" {
  type = string
}

variable "additional_tags" {
  type = map(string)
  default = {}
}

locals {
  basic_tags = tomap({
    "Name" : "SG-${upper(var.sg_server_name)}"
  })
}