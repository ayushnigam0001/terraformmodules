resource "aws_lb" "this" {
  name               = var.app_load_balancer_name
  internal           = var.is_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.load_balancer_security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.is_deletion_protection_enable

  tags = merge(local.load_balancer_tag, var.additional_tags)
}

resource "aws_lb_target_group" "this" {
  name            = var.target_group_name
  port            = var.target_group_port
  protocol        = var.target_group_protocol
  vpc_id          = var.vpc_id
  target_type     = "ip"
  ip_address_type = "ipv4"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    path                = var.health_check_path
    timeout             = 4
    unhealthy_threshold = 3
  }

  tags = merge(local.target_group_tags)
}

##################################################

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.load_balancer_listining_port
  protocol          = var.load_balancer_listining_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Incorrect Path"
    }
  }
  tags = local.lb_listners_tags
}


resource "aws_lb_listener_rule" "rule1" {
  listener_arn = aws_lb_listener.this.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = var.list_of_forwarding_path_pattern
    }
  }
  tags = local.lb_listner_rule_tags
}

resource "aws_lb_target_group_attachment" "this" {
  count            = length(var.forwarding_to)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.forwarding_to[count.index].ip
  port             = var.forwarding_to[count.index].port
}