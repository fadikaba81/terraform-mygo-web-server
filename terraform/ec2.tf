resource "aws_instance" "web_server" {

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc_public_subnet["public_subnet_1"].id
  security_groups             = [aws_security_group.sg_http.id, aws_security_group.sg_http.id, aws_security_group.sg_ping.id]
  associate_public_ip_address = true

}

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

