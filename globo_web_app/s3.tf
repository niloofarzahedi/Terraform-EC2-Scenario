#aws_s3_bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = local.s3_bucket_name
  #allows terraform to destroy the bucket even if it's not empty
  force_destroy = true
  tags          = local.common_tags
}
#aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.s3-bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY
}
#aws_s3_objects
resource "aws_s3_object" "web-objects" {
  for_each = local.website_content
  bucket   = aws_s3_bucket.s3-bucket.bucket
  key      = each.value
  source   = "${path.root}/${each.value}"
  tags     = local.common_tags
}