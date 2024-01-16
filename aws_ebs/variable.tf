variable "availability_zone" {
  type = string
  validation {
    condition = can(regex("^ap-south-1", var.availability_zone))
    error_message = "Only ap-south-1 is allowed"
  }
}

variable "volume_size" {
  type = number
}

variable "regular_tag" {
  type = map(string)
}
variable "additional_tags" {
  type = map(string)
  default = {}
}