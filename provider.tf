terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "aijazk2406-adminuser"
  region                   = "ap-southeast-2"
}