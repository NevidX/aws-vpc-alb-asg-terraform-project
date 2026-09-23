module "dev_vpc" {
  source = "../../modules/vpc" 

  environment        = "dev"
  vpc_cidr           = "10.1.0.0/16"
  public_subnet_cidr = "10.1.1.0/24"
  private_subnet_cidr_1 = "10.1.2.0/24"
  private_subnet_cidr_2 = "10.1.3.0/24"

}


module "web_server" {
  source = "../../modules/ec2"

  environment       = "dev"
  subnet_id         = module.dev_vpc.tf_subnet_public_id
  security_group_id = module.dev_vpc.web_security_group_id
   
}

module "rds" {
  source = "../../modules/rds"

  environment           = "dev"
  vpc_id                = module.dev_vpc.tf_vpc_id
  db_subnet_group_name  = module.dev_vpc.db_subnet_group_name
  web_security_group_id = module.dev_vpc.web_security_group_id

  db_name     = "devdb"
  db_username = var.db_username
  db_password = var.db_password
}