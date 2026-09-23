variable "instance_type" {
  description = "instance type for EC2"
  type        = string
  default     = "t3.micro"
}
variable "environment" {
  type        = string
  description = "Environment name"
}

variable "security_group_id" {
  type        = string
  description = "security_group_id for EC2"
}


variable "subnet_id" {
  type        = string
  description = "Public Subnet ID for EC2"
}


