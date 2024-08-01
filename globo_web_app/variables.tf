variable "vpc_cidr_block" {
  type        = string
  description = "VPC cidr block"
  default     = "10.0.0.0/16"
}
variable "aws_subnet_count" {
  type    = number
  default = 2
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
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
variable "naming_prefix" {
  type        = string
  description = "a name prefix"
  default     = "globo-web-app"
}
variable "enviroment_name" {
  type        = string
  description = "it identifies which enviroment are we in right now"
  default     = "dev"
}