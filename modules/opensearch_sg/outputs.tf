output "security_group_ids" {
  description = "List of security group IDs"
  value       = [for sg in aws_security_group.opensearch_sg : sg.id]
}

output "security_group_names" {
  description = "The names of the created security groups"
  value       = { for sg in aws_security_group.opensearch_sg : sg.name => sg.name }
}