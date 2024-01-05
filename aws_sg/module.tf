resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
  for_each = var.inbound_ports
  content {
    description = ingress.value["description"]
    from_port   = ingress.value["from_port"]
    to_port     = ingress.value["to_port"]
    protocol    = ingress.value["protocol"]
    cidr_blocks = ingress.value["cidr_block"]
  }
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge(local.basic_tags, var.additional_tags)
}