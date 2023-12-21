resource "aws_instance" "ec2_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key
  disable_api_termination = var.enable_termination_protection
  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index = 0
  }
  tags = {
    "Name" = var.server_name
  }
}

resource "aws_network_interface" "eni" {
  subnet_id = var.subnet_id
  security_groups = var.security_group_list
  tags = {
    "Name" = "eni-${var.server_name}"
  }
}