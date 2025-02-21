terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.36.0"
      configuration_aliases = [aws.us-east-1]
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
