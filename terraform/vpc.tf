resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc_block

  tags = {
    Name        = var.vpc_name
    Environment = terraform.workspace
  }
}

data "aws_availability_zones" "availability" {}


resource "aws_internet_gateway" "vpc_ig" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "fadikaba_ig"
  }

}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
  }

  tags = {
    Name = "vpc_route_table"
  }
}

resource "aws_subnet" "vpc_private_subnet" {

  for_each          = var.vpc_private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_vpc_block, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.availability.names)[each.value % length(data.aws_availability_zones.availability.names)]

  tags = {
    AZ        = data.aws_availability_zones.availability.state
    Name      = each.key
    Terraform = true
  }
}

resource "aws_subnet" "vpc_public_subnet" {

  for_each          = var.vpc_public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_vpc_block, 8, each.value + 100)
  availability_zone = tolist(data.aws_availability_zones.availability.names)[each.value % length(data.aws_availability_zones.availability.names)]

  map_public_ip_on_launch = true

  tags = {
    AZ        = data.aws_availability_zones.availability.state
    Name      = each.key
    Terraform = true
  }
}