output "vpc_id" {
  description = "생성된 VPC의 ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "생성된 Public Subnet들의 ID 목록"
  value       = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnet_ids" {
  description = "생성된 Private Subnet들의 ID 목록"
  value       = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "alb_dns_name" {
  description = "ALB의 DNS 이름"
  value       = aws_lb.alb.dns_name
}