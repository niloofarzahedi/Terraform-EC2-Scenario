output "aws_instance_dns_name" {
  value       = "https://${aws_instance.nginx1.public_dns}"
  description = "dns of server"
}
