# Launch Template for EC2 instances
resource "aws_key_pair" "tf_key_pair" {
  key_name   = "${var.environment}-ssh-key"
  public_key = var.ssh_public_key
}

resource "aws_launch_template" "tf_launch_template" {
  name_prefix   = "${var.environment}-app-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.tf_key_pair.key_name

# Linking IAM Profile for SSM to work
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_ssm_profile.arn
  }


  # Keep instances isolated in private subnets
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_security_group_id]
  }

  # Apache web server setup script
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              apt-get update -y
              apt-get install -y stress
              
              EC2_HOST=$(hostname -f)
              echo "<h1>Hello from High Availability AWS Architecture!</h1><p>Served by Instance: <b>$EC2_HOST</b></p>" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-asg-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group across Multi-AZ private subnets
resource "aws_autoscaling_group" "tf_asg" {
  name_prefix         = "${var.environment}-asg-"
  vpc_zone_identifier = var.private_subnet_ids

  # ALB target group integration and health checks
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.tf_launch_template.id
    version = "$Latest"
  }

  # Instance tags
  dynamic "tag" {
    for_each = {
      Name        = "${var.environment}-asg-worker"
      Environment = var.environment
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

#  IAM Role for EC2 instances
resource "aws_iam_role" "ec2_ssm_role" {
  name_prefix = "${var.environment}-ec2-ssm-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}



# Attaching a standard AWS managed policy for SSM connection to instaces for debugging
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an Instance Profile that is transferred to EC2
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name_prefix = "${var.environment}-ec2-ssm-profile-"
  role        = aws_iam_role.ec2_ssm_role.name
}

# Policy for autoscaling based on CPU load.
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.environment}-cpu-target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.tf_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    # limit of CPU in whole ASG
    target_value = 50.0
  }
}