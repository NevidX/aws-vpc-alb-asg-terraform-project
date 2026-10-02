

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
resource "aws_subnet" "tf_subnet_public_1" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true 

  tags = {
    Name = "tf-public-subnet-1"
  }
}

resource "aws_subnet" "tf_subnet_public_2" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_subnet_cidr_2
    availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true 

  tags = {
    Name = "tf-public-subnet-2"
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
# --------------------------------------------------




# 4. (Internet Gateway)
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

resource "aws_eip" "nat-gateway-eip" {
  domain = "vpc" 

  tags = {
    Name = "nat-gateway-eip"
  }
}

# NAT Gateway for instances to able to take updates 
resource "aws_nat_gateway" "tf_nat_gateaway" {
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id     = aws_subnet.tf_subnet_public_1.id

  tags = {
    Name = "nat_gateaway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.tf_igw]
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

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat_gateaway.id
  }


  tags = {
    Name = "tf-private-route-table"
  }
}
#  -------------------------------


# route table associations -----------------------------------

# route table association for public subnet 1
resource "aws_route_table_association" "tf_rta_public_1" {
  subnet_id      = aws_subnet.tf_subnet_public_1.id
  route_table_id = aws_route_table.tf_route_table_public.id
}
# route table association for public subnet 2
resource "aws_route_table_association" "tf_rta_public_2" {
  subnet_id      = aws_subnet.tf_subnet_public_2.id
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


#6.Security Group 
# Security Group for ALB (public)
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Allow public HTTP traffic to ALB"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}



# Security Group for EC2 in private subnets
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Allow HTTP only from ALB Security Group"
  vpc_id      = aws_vpc.tf_vpc.id

  # Allow port 80 ONLY from the Security Group balancer
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

/*   # SSH for debugging
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 */
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-sg"
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

