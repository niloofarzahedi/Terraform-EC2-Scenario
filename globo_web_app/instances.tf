# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count         = 2
  ami           = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type = var.instance_type
  #in case we had more instances than subnets
  subnet_id              = aws_subnet.public_subnets[(count.index % var.aws_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  tags                   = merge(local.common_tags,{Name="${local.prefix}-nginx-${count.index}"})
  # Attach the instance profile to your EC2 instance
  iam_instance_profile = aws_iam_instance_profile.nginx_profile.name
  #this tells terraform to wait for this role policy to finish creation and then create this ec2 instance
  #this is not a ec2 attr, this is a terraform meta argument
  depends_on = [aws_iam_role_policy.allow_s3_all]
  #first arg is path to .tpl file and second arg is a map of all data that we want to pass to .tpl file
  #${path.cwd} is path to my current dir
  user_data = templatefile("${path.cwd}/templates/startup_script.tpl", { aws_s3_bucket = aws_s3_bucket.s3-bucket.id })

}

# S3 access for instances
resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  #by next line we are saying ec2 instances can take this iam role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name
  #allow users with this iam role to have access to s3 buckets
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF

}
