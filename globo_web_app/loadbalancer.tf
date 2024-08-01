# aws_elb_service_account
data "aws_elb_service_account" "root" {}
#lb 
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
  #because depends_on expect a list of resources we put bruckets around it.
  depends_on = [aws_s3_bucket_policy.web_bucket]
  #if you set this to True, terraform cannot destroy it
  enable_deletion_protection = false
  access_logs {
    bucket  = aws_s3_bucket.s3-bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }
  tags = merge(local.common_tags,{Name="${local.prefix}"})
}
#lb target group
resource "aws_lb_target_group" "nginx_alb_target_group" {
  name     = "nginxlbtargetgroup"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.app.id
  tags     = merge(local.common_tags,{Name="${local.prefix}"})
}
#lb listener
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

#lb target group attachment
resource "aws_lb_target_group_attachment" "nginx_alb_target_group_attachments" {
  count            = 2
  target_group_arn = aws_lb_target_group.nginx_alb_target_group.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}
