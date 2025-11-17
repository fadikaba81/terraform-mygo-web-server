
variable "cidr_vpc_block" {
  type        = string
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}


variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "fadikaba_vpc"

}

variable "vpc_private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3

  }
}

variable "vpc_public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3

  }
}

variable "dbpass" {
  type        = string
  description = "This is DB Password, it will be move to Terraform Cloud"

}

variable "enviornment" {
  type    = string
  default = "dev"

}