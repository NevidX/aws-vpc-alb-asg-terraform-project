variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where Target Group will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of the Security Group for the ALB"
  type        = string
}



