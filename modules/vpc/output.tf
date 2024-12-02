output "vpc_id" {
  description = "ID of the VPC instance"
  value       = aws_vpc.vpc.id
}

output "aws_subnets" {
  description = "subnet public generated"
  value       = aws_subnet.subnet-public
}