

# 2. Creating VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "tf_vpc_${var.environment}"
  }
}

# Subnets -----------------------------------
#  (Public Subnet)
resource "aws_subnet" "tf_subnet_public" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true 

  tags = {
    Name = "tf-public-subnet"
  }
}

resource "aws_subnet" "tf_subnet_private_1" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.private_subnet_cidr_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false 

  tags = {
    Name = "tf-private-subnet-1"
  }
}
resource "aws_subnet" "tf_subnet_private_2" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-private-subnet-2"
  }
}
# Subnet group of private subnets
resource "aws_db_subnet_group" "tf_db_private_subnet_group" {
  name        = "${var.environment}-db-subnet-group"
  subnet_ids  = [aws_subnet.tf_subnet_private_1.id, aws_subnet.tf_subnet_private_2.id]

  tags = {
    Name = "tf-db-private-subnet-group"
  }
}

# --------------------------------------------------




# 4. (Internet Gateway)
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

# 5. Route Tables -------------------------------
resource "aws_route_table" "tf_route_table_public" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "tf-public-route-table"
  }
}

resource "aws_route_table" "tf_route_table_private" {
  vpc_id = aws_vpc.tf_vpc.id


  tags = {
    Name = "tf-private-route-table"
  }
}
#  -------------------------------


# route table associations -----------------------------------

# route table association for public subnet
resource "aws_route_table_association" "tf_rta_public" {
  subnet_id      = aws_subnet.tf_subnet_public.id
  route_table_id = aws_route_table.tf_route_table_public.id
}

# route table association for private subnet 1
resource "aws_route_table_association" "tf_rta_private_1" {
  subnet_id      = aws_subnet.tf_subnet_private_1.id
  route_table_id = aws_route_table.tf_route_table_private.id
}

# route table association for private subnet 2
resource "aws_route_table_association" "tf_rta_private_2" {
  subnet_id      = aws_subnet.tf_subnet_private_2.id
  route_table_id = aws_route_table.tf_route_table_private.id
}

# -----------------------------------


# 6. Security Group 
resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



/* S3 bucket with versioning */
resource "aws_s3_bucket" "tf-bucket" {
  bucket = "tf-bucket-43-nev-${var.environment}"

  tags = {
    Name = "tf-bucket"
  }
}

resource "aws_s3_bucket_versioning" "tf-bucket-versioning" {

bucket = aws_s3_bucket.tf-bucket.id
  versioning_configuration {
    status = "Enabled"
  }

  
}
/* --------------------------- */

