module "gitlab" {
  source     = "./modules/gitlab"
  subnet_ids = module.shared_vpc.private_subnets
  environment_name = var.environment_name
}

resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
