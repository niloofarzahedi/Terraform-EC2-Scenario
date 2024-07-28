variable "aws_region" {
  type        = string
  description = "aws region name"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "subnets_cidr_block" {
  type        = list(string)
  description = "subnet cidr block"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnet_map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "instance_type" {
  type        = string
  description = "this is our server type"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "company name for resource tagging"
  default     = "Globomantics"
}

variable "project" {
  type        = string
  description = "project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "billing code for resource tagging"
}
