resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
  for_each = var.sg_details
  content {
    from_port = ingress.from_port
    to_port = ingress.to_port
    protocol = ingress.protocol
    cidr_blocks = ingress.cidr_block
    description = ingress.description
  }
}
  ingress {
    description = "Self referancing SG"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  egress = {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.sg_server_name}-sg"
  }
}