variable "aws_provider_role_arn" {
  description = "IAM Role ARN for AWS provider to assume."
  type        = string
}

provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = var.aws_provider_role_arn
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  assume_role {
    role_arn = var.aws_provider_role_arn
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token

  # Useful if Terraform needs to make a change that results in problems connecting to the cluster
  # config_path = "~/.kube/config"
  # config_context = "eks-${var.environment_name}"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "auth0" {
  domain = var.auth0_tenant_domain
  client_id = var.auth0_client_id
  client_secret = var.auth0_client_secret
}

terraform {
  backend "s3" {
    bucket               = "120water-terraform"
    workspace_key_prefix = "tf-workspace"
    key                  = "aws-infra.tfstate"
    dynamodb_table       = "terraform-state-lock"
    region               = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.36.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }

    auth0 = {
      source  = "auth0/auth0"
      version = "1.1.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }

    http = {
      source = "terraform-aws-modules/http"
      version = "2.4.1"
    }
  }
}
