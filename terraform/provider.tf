provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Name        = "Web Server Project"
      Owner       = "Fadi Kaba"
      Environment = "Dev"
    }
  }
}