
output "web_public_ip" {
  description = "Public IP address of the EC2 Web Server"
  value       = module.web_server.instance_public_ip 
}


output "rds_endpoint" {
  description = "Connection endpoint for the RDS database"
  value       = module.rds.db_endpoint 
}