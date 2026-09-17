provider "aws" {
  region = "eu-central-1"
}

# 1. Make a request of most recente AMI Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# 2. Creating VPC
resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
  }
}

# 3. (Public Subnet)
resource "aws_subnet" "test_subnet" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Выдает публичный IP-адрес запускаемым инстансам

  tags = {
    Name = "test-public-subnet"
  }
}

# 4. (Internet Gateway)
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-igw"
  }
}

# 5. (Route Table) 
resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "test-public-route-table"
  }
}

# Привязываем таблицу маршрутизации к нашей подсети
resource "aws_route_table_association" "test_rta" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_rt.id
}

# 6. Группа безопасности (Security Group) — Файрвол
resource "aws_security_group" "test_sg" {
  name        = "test-security-group"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  # Разрешаем SSH (порт 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем HTTP (порт 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем весь исходящий трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. Сам инстанс EC2 (Amazon Linux 2023)
resource "aws_instance" "test_web" {
  ami                    = data.aws_ami.amazon_linux_2023.id # Вызывается динамически
  instance_type          = "t3.micro"                        # или t3.micro (тоже входит в Free Tier для AL2023)
  subnet_id              = aws_subnet.test_subnet.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  tags = {
    Name = "MyFirstTerraformEC2"
  }
}

# 8. Вывод публичного IP-адреса созданного инстанса в консоль
output "ec2_public_ip" {
  value       = aws_instance.test_web.public_ip
  description = "Public IP of the created EC2 instance"
}