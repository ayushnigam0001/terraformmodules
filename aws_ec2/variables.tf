variable "ami_id" {
  type = string
  validation {
    condition     = can(regex("^ami-", var.ami_id))
    error_message = "Invalid Image Id"
  }
}
variable "instance_type" {
  type = string
  validation {
    condition     = can(regex("t2\\.micro|t2\\.medium", var.instance_type))
    error_message = "Only t2.micro and t2.medium are permited"
  }
}
variable "subnet_id" {
  type = string
  validation {
    condition     = can(regex("^subnet-", var.subnet_id))
    error_message = "Invalid Subnet Id"
  }
}
variable "key" {
  type = string
}
variable "enable_termination_protection" {
  type    = bool
  default = false
}
variable "security_group_list" {
  type = list(string)
}

variable "server_name" {
  type = string
}

variable "ebs_block_devices" {
  type = list(object({
    device_name = string
    volume_size = number
  }))
  default = []
}

variable "volume_type" {
  type = string
  default = "gp3"
  validation {
    condition = can(regex("gp3|gp2", var.volume_type))
    error_message = "Only gp3 and gp2 allowed"
  }
}

variable "availability_zone" {
  type = string
  validation {
    condition = can(regex("[abcd]$", var.availability_zone))
    error_message = "Enter Valid AZ"
  }
}

variable "volume_size" {
  type = number
}