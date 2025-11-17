terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  required_version = "~>1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.19.0"

    }
    tls = {
      source  = "hashicorp/tls"
      version = "=4.1.0"

    }
  }
}