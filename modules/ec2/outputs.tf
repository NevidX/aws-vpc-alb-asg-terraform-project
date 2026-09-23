

output "instance_public_ip" {
  value       = aws_instance.tf_web_server.public_ip
  description = "Public IP of the Web Server"
}