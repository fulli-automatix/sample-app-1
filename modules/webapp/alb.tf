
resource "aws_lb" "web_alb" {
  name               = "${var.default_tags["Environment"]}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnet_ids.public_subnets.ids

  enable_deletion_protection = false


  tags = merge(
    var.default_tags,
    {
      Name = "web-alb"
    }
  )
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.default_tags["Environment"]}-lb-sg"
  description = "Security group governing traffic to and from Application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  tags = merge(
    var.default_tags,
    {
      Name = "${var.default_tags["Environment"]}-lb-sg"
    }
  )
}



resource "aws_lb_listener" "web_app_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "${var.default_tags["Environment"]}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
  for_each         = aws_instance.web_server
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = aws_instance.web_server[each.key].id
  port             = 80
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.web_app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

}