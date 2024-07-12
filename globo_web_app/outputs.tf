output "aws_instance_dns_name" {
  value       = "https://${aws_instance.nginx1.public_dns}"
  description = "dns of server"
}

output "public_subnet1_availability_zone" {
  value       = "AZ subnet 1${aws_subnet.public_subnet1.availability_zone}"
  description = "public subnet 1 az"
}

output "public_subnet2_availability_zone" {
  value       = "AZ subnet 2${aws_subnet.public_subnet2.availability_zone}"
  description = "public subnet 2 az"
}
