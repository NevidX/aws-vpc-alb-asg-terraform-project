# AWS Region and Environment
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# Network Variables for VPC Module
variable "vpc_cidr" {
  description = "Base CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for first public subnet"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for second public subnet"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for first private subnet"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for second private subnet"
  type        = string
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
}

# Compute Variables for ASG Module
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 2
}

variable "public_subnet_1_id" {
  description = "ID of the Security Group for the ALB"
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID of the Security Group for the ALB"
  type        = string
}