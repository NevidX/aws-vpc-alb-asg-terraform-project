terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "my-tfstate-bucket-43"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile = true
  }
}