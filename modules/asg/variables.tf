variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Ubuntu/Amazon Linux)"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_security_group_id" {
  description = "Security Group ID for EC2 instances"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets IDs for ASG deployment"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group to register instances"
  type        = string
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 2
}