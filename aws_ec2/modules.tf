resource "aws_instance" "ec2_server" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key
  disable_api_termination = var.enable_termination_protection
  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }
  root_block_device {
    delete_on_termination = true
      volume_type           = var.volume_type
      volume_size           = var.root_volume_size
      tags = {
        "Name" = "${var.server_name}-RootVolume" 
      }
  }
  tags = {
    "Name" = var.server_name
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }
}

resource "aws_ebs_volume" "this" {
  count             = length(var.ebs_block_devices)
  size              = var.ebs_block_devices[count.index].volume_size
  type              = var.volume_type
  availability_zone = var.availability_zone
  tags = {
    "Name" = "${var.server_name}-NonRoot-${count.index}"
  }
}

resource "aws_volume_attachment" "this" {
  count       = length(var.ebs_block_devices)
  device_name = var.ebs_block_devices[count.index].device_name
  instance_id = aws_instance.ec2_server.id
  volume_id   = aws_ebs_volume.this[count.index].id
}

resource "aws_network_interface" "eni" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_list
  tags = {
    "Name" = "eni-${var.server_name}"
  }
}