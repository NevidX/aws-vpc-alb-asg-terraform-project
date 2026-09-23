module "prod_vpc" {
  source             = "../../modules/vpc"
  environment        = "prod"
  vpc_cidr           = "10.30.0.0/16"
  public_subnet_cidr = "10.30.1.0/24"
}