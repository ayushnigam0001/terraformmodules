variable "forwarding_to" {
  type = list(object({
    ip   = string
    port = number
  }))
}

variable "list_of_forwarding_path_pattern" {
  type = list(string)
}

variable "load_balancer_listining_port" {
  type = number
}

variable "load_balancer_listining_protocol" {
  type = string
}

variable "vpc_id" {
  type = string
  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "value"
  }
}

variable "target_group_name" {
  type = string
}

variable "app_load_balancer_name" {
  type = string
}

variable "is_internal" {
  type = bool
}

variable "load_balancer_type" {
  type = string
  validation {
    condition     = can(regex("[(application)|(network)]", var.load_balancer_type))
    error_message = "Only application and network load balancer are allowed!!!"
  }
}

variable "load_balancer_security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "is_deletion_protection_enable" {
  type    = bool
  default = false
}

variable "target_group_port" {
  type = number
}

variable "target_group_protocol" {
  type = string
}

variable "health_check_path" {
  type = string
}

locals {
  load_balancer_tag = tomap({
    "Name" : var.app_load_balancer_name
  })

  target_group_tags = tomap({
    "Name" : "TG-${upper(var.app_load_balancer_name)}"
  })

  lb_listners_tags = tomap({
    "Name" : "LoadBalancer-${var.app_load_balancer_name}-listner"
  })

  lb_listner_rule_tags = tomap({
    "Name" : "Rules-for-listner-of-${var.app_load_balancer_name}"
  })
}

variable "additional_tags" {
  type = map(string)
  default = {}
}