

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

resource "aws_vpc" "app" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  #when you have already applied a resource and now you want to add something to tags you can use merge function
  #merge(old tags, new components)
  tags=merge(local.common_tags, {Name="${local.prefix}-vpc"})
  #tags                 = local.common_tags
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags
}

resource "aws_subnet" "public_subnets" {
  count = var.aws_subnet_count
  #first arg is the vpc net mask, the second arg is the number of bits that we want to add to mask, the third arg is now which new subnet we want to have
  #e.g 10.0.0.0/16 is vpc, the new subnetmask is 10.0.[0.254].0/24, you can choose 10.0.0.0/24,10.0.1.0/24,...
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  tags                    = merge(local.common_tags,{Name="${local.prefix}-subnet-${count.index}"})
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "app_subnets" {
  count          = var.aws_subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS #
#ALB security group
resource "aws_security_group" "ALB_sg" {
  name   = "alb_sg"
  vpc_id = aws_vpc.app.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags,{Name="${local.prefix}-alb-sg"})
}
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_albsg"
  vpc_id = aws_vpc.app.id

  # HTTP access from alb
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags,{Name="${local.prefix}-nginx-sg"})
}

