terraform {
  backend "s3" {
    bucket       = "my-tfstate-bucket-43"
    key          = "prod/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}