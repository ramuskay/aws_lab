output "free_tier_instance_types" {
  value = data.aws_ec2_instance_types.free_tier_types.instance_types
}

output "instance_public_ip" {
  value = aws_instance.ec2.public_ip
}