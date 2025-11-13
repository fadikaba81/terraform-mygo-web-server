resource "aws_db_instance" "rds_mysql" {
  allocated_storage           = 5
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  #manage_master_user_password = true
  username                    = "fkaba"
  password                    = var.dbpass
  parameter_group_name        = "default.mysql8.0"
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids      = [aws_security_group.sg_mysql.id]
  identifier = "mysqldb"
  skip_final_snapshot = true
  }
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "mysql-subnet"
  subnet_ids = [aws_subnet.vpc_private_subnet["private_subnet_1"].id, aws_subnet.vpc_private_subnet["private_subnet_2"].id, aws_subnet.vpc_private_subnet["private_subnet_3"].id]
  tags = {
    Name = "Mysql Subnet"
  }
}