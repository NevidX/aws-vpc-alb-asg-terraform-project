# 1. Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-rds-sg"
  description = "Allow MySQL access strictly from Web SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.web_security_group_id] # access only Web SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-rds-sg"
  }
}

# 2.  RDS MySQL
resource "aws_db_instance" "tf_rds" {
  identifier             = "${var.environment}-db-instance"
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false # no public ip
  skip_final_snapshot    = true  # for testing 

  tags = {
    Name = "${var.environment}-rds"
  }
}