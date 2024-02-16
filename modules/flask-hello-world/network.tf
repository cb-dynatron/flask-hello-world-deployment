data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.name_prefix}-alb-sg"
  description = "Allow all HTTPS traffic from public"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  subnets            = toset(data.aws_subnets.default.ids)
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "ecs_svc_2" {
  name_prefix = "tgt-"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 8888
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    port                = 8888
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_svc_2.id
  }
}
