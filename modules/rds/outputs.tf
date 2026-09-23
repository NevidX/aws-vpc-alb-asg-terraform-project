output "db_endpoint" {
  value       = aws_db_instance.tf_rds.endpoint
  description = "RDS connection endpoint"
}

output "db_address" {
  value       = aws_db_instance.tf_rds.address
  description = "RDS internal hostname"
}

output "db_port" {
  value       = aws_db_instance.tf_rds.port
  description = "RDS port"
}