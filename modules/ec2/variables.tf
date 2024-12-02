variable "region" {
  description = "The region where to deploy"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "profile" {
  description = "The profile to use to create/destroy resources"
  type        = string
}

variable "az_of_the_ec2" {
    description = "We will deploy in multiple ec2 but only one will host the EC2 instance"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "aws_subnets" {
  description = "subnet public generated"
  type = map(any)
}