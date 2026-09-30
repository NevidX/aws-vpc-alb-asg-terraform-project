# 1. Target Group для EC2 инстансов
resource "aws_lb_target_group" "tf_tg" {
  name     = "${var.environment}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.environment}-tg"
  }
}

# 2. Application Load Balancer
resource "aws_lb" "tf_alb" {
  name               = "${var.environment}-alb"
  internal           = false # Публичный балансировщик
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.environment}-alb"
  }
}

# 3. ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_tg.arn
  }
}