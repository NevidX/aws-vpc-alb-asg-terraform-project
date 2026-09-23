module "stage_vpc" {
  source             = "../../modules/vpc"
  environment        = "stage"
  vpc_cidr           = "10.20.0.0/16"
  public_subnet_cidr = "10.20.1.0/24"
}