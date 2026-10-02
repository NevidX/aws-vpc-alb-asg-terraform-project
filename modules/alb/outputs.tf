# Target Group ARN required for Auto Scaling Group attachment
output "target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_lb_target_group.tf_tg.arn
}

# Public DNS Name of the Load Balancer
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.tf_alb.dns_name
}