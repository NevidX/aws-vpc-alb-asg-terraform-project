# 8. Debug in console of public IP
/* output "ec2_public_ip" {
  value       = aws_instance.test_web.public_ip
  description = "Public IP of the created EC2 instance"
} */

output "web_security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "ID of the Web Security Group created in VPC"
}

output "tf_subnet_public_id" {
  value       = aws_subnet.tf_subnet_public.id
  description = "ID of the piblic subnet created in VPC"
}

output "tf_vpc_id" {
  value       = aws_vpc.tf_vpc.id
  description = "ID of created VPC"
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.tf_db_private_subnet_group.name
}

# Public Subnet IDs
output "public_subnet_1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.tf_subnet_public_1.id
}

output "public_subnet_2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.tf_subnet_public_2.id
}

output "private_subnet_1_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.tf_subnet_private_1.id
}

output "private_subnet_2_id" {
  description = "ID of the second private subnet"
  value       = aws_subnet.tf_subnet_private_2.id
}

output "alb_security_group_id" {
  description = "ID of Security Group for ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "ID of Security Group for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}