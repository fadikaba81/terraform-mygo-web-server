resource "aws_instance" "ec2_web_server" {
  depends_on    = [aws_db_instance.rds_mysql]
  ami           = data.aws_ami.ec2_ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.vpc_public_subnet["public_subnet_1"].id
  security_groups = [aws_security_group.sg_http.id,
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_ping.id,
  aws_security_group.sg_mysql.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key.key_name
  user_data                   = file("script.sh")


}

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ec2_ubuntu" {
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

resource "aws_key_pair" "ec2_key" {
  key_name   = "MyAWSKeys${var.enviornment}"
  public_key = tls_private_key.ec2_tls_key.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

resource "tls_private_key" "ec2_tls_key" {
  algorithm = "RSA"

}

