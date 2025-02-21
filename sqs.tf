module "add_file_to_batch_zip_dlq" {
  source           = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"
  name             = "add-file-to-batch-zip-dlq"
  environment_name = var.environment_name
}

module "add_file_to_batch_zip" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"

  name                           = "add-file-to-batch-zip"
  environment_name               = var.environment_name
  dead_letter_queue_arn          = module.add_file_to_batch_zip_dlq.arn
  dead_letter_queue_max_receives = 5
  visibility_timeout_seconds     = 960 
}

module "add_file_to_batch_zip_fifo" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue_fifo?ref=v1.3.2"

  name                           = "add-file-to-batch-zip"
  environment_name               = var.environment_name
  visibility_timeout_seconds     = 960 
}

module "file_added_to_zip_dlq" {
  source           = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"
  name             = "file-added-to-zip-dlq"
  environment_name = var.environment_name
}

module "file_added_to_zip" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"

  name                           = "file-added-to-zip"
  environment_name               = var.environment_name
  dead_letter_queue_arn          = module.file_added_to_zip_dlq.arn
  dead_letter_queue_max_receives = 5
  visibility_timeout_seconds     = 120 
}

module "lob_requests_dlq" {
  source           = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"
  name             = "lob-requests-dlq"
  environment_name = var.environment_name
}

module "lob_requests" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"

  name                           = "lob-requests"
  environment_name               = var.environment_name
  dead_letter_queue_arn          = module.lob_requests_dlq.arn
  dead_letter_queue_max_receives = 5
  visibility_timeout_seconds     = 120 
}

module "lob_results_dlq" {
  source           = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"
  name             = "lob-results-dlq"
  environment_name = var.environment_name
}

module "lob_results" {
  source = "git@gitlab.com:120-water/infrastructure/terraform-modules.git//sqs_queue?ref=v1.3.2"

  name                           = "lob-results"
  environment_name               = var.environment_name
  dead_letter_queue_arn          = module.lob_results_dlq.arn
  dead_letter_queue_max_receives = 5
  visibility_timeout_seconds     = 120 
}