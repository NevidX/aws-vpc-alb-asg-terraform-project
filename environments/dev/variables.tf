variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Global environment name"
  type        = string
  default     = "dev"
}

variable "db_password" {
  type        = string
  description = "RDS master password"
  sensitive   = true 
}

variable "db_username" {
  type        = string
  description = "RDS master username"
  sensitive   = true 
}