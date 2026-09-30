

# 1. VPC Module (Networking)
module "vpc" {
  source = "../../modules/vpc"

  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr_1  = var.public_subnet_cidr_1
  public_subnet_cidr_2  = var.public_subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

# 2. ALB Module (Load Balancing)
module "alb" {
  source = "../../modules/alb"

  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = [
    module.vpc.public_subnet_1_id,
    module.vpc.public_subnet_2_id
  ]
  alb_security_group_id = module.vpc.alb_security_group_id
}

# 3. ASG Module (Compute & Auto Scaling)
module "asg" {
  source = "../../modules/asg"

  environment           = var.environment
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  ec2_security_group_id = module.vpc.ec2_security_group_id
  private_subnet_ids    = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]
  target_group_arn      = module.alb.target_group_arn
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
}
