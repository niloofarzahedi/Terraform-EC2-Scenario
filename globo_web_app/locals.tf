locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
    enviroment   = var.enviroment_name
  }
  s3_bucket_name = "${lower(local.prefix)}-${random_integer.s3.result}"
  website_content = {
    website = "/website/index.html",
    pic     = "/website/Globo_logo_Vert.png"
  }
  prefix = "${var.naming_prefix}-${var.enviroment_name}"
}
resource "random_integer" "s3" {
  min = 10000
  max = 999999
}
