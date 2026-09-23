variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Security Group for RDS will be created"
}

variable "db_subnet_group_name" {
  type        = string
  description = "DB Subnet Group name from VPC module"
}

variable "web_security_group_id" {
  type        = string
  description = "Security Group ID of Web Server to allow ingress traffic"
}

variable "db_name" {
  type        = string
  default     = "mydb"
  description = "Initial database name"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "Master username for RDS"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password for RDS (pass via tfvars or secrets)"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Allocated storage in GB"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS instance class"
}