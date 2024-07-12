output "aws_alb_dns_name" {
  value       = "http://${aws_lb.nginx_alb.dns_name}"
  description = "dns of application load balancer"
}

output "public_subnet1_availability_zone" {
  value       = "AZ subnet 1${aws_subnet.public_subnet1.availability_zone}"
  description = "public subnet 1 az"
}

output "public_subnet2_availability_zone" {
  value       = "AZ subnet 2${aws_subnet.public_subnet2.availability_zone}"
  description = "public subnet 2 az"
}
