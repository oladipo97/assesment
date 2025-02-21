module "cdn" {
  source = "./modules/cdn"

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  environment_name = var.environment_name
  domain_name      = var.cdn_domain_name
}