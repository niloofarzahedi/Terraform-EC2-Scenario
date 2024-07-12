#alb 
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  #if you set this to True, terraform cannot destroy it
  enable_deletion_protection = false

  tags = local.common_tags
}
#alb target group
resource "aws_lb_target_group" "nginx_alb_target_group" {
  name     = "nginxlbtargetgroup"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.app.id
  tags     = local.common_tags
}
#alb listener
resource "aws_lb_listener" "nginx_alb_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.nginx_alb_target_group.arn
    type             = "forward"
  }
  tags = local.common_tags
}

#alb target group attachment
resource "aws_lb_target_group_attachment" "nginx_alb_target_group_attachment1" {
  target_group_arn = aws_lb_target_group.nginx_alb_target_group.arn
  target_id        = aws_instance.nginx1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "nginx_alb_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.nginx_alb_target_group.arn
  target_id        = aws_instance.nginx2.id
  port             = 80
}
