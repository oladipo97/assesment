output "id" {
  description = "The ID of the created security group"
  value       = aws_security_group.rds_access_sg.id
}