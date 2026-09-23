 #  EC2 (Amazon Linux 2023)
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

# 3. EC2 Instance
resource "aws_instance" "tf_web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type 
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  # Install nginx on start
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello from ${var.environment} Web Server!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${var.environment}-web-server"
  }
}

