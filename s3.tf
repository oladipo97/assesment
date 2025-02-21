module "communications-s3-bucket" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//s3?ref=v1.3.1"
  providers = {
    aws            = aws
  }
  bucket_name = "120water-communications-${var.environment_name}"
  canned_acl = "private"
}

module "reports-s3-bucket" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//s3?ref=v1.3.1"
  providers = {
    aws            = aws
  }
  bucket_name = "120water-reports-${var.environment_name}"
  canned_acl = "private"
}



