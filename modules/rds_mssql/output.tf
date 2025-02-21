output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret"
  value       = module.db.db_instance_master_user_secret_arn
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.db_instance_id
}