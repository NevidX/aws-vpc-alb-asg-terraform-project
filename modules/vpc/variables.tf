variable "aws_region" {
  description = "AWS region for infrastructure"
  type        = string
  default     = "eu-central-1"
}


variable "environment" {
  description = "environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for public subnet"
}

variable "private_subnet_cidr_1" {
  type        = string
  description = "CIDR block for private subnet 1"
}

variable "private_subnet_cidr_2" {
  type        = string
  description = "CIDR block for private subnet 2"
}

variable "availability_zone_1" {
  type        = string
  description = "availability_zone_1"
  default = "eu-central-1a"
}

variable "availability_zone_2" {
  type        = string
  description = "availability_zone_2"
  default = "eu-central-1b"
}

