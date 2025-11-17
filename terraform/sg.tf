resource "aws_security_group" "sg_ssh" {
  name   = "Ingress SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allowing Ingress on Port 22"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    description = "Allowing Egress on Port 0"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
}

resource "aws_security_group" "sg_http" {
  name   = "HTTP"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allowing Ingress on Port 80"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
  }

  ingress {
    description = "Allowing Ingress on port 443"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  egress {
    description = "Allowing Egress on port 0"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

}
resource "aws_security_group" "sg_ping" {
  name   = "Ping"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allowing Ingress for Ping"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
  }

  egress {
    description = "Allowing Outbound on port 0"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "icmp"
  }

}

resource "aws_security_group" "sg_mysql" {
  name        = "Mysql Connections"
  description = "Allowing a connection to MySQL DB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allowing port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    description = "Allowing port 3306"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "MySQL Port"
  }

}