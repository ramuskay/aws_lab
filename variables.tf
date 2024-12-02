variable "region" {
  description = "The region where to deploy"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "profile_admin" {
  description = "The admin profile to use to create/destroy resources"
  type        = string
}

variable "profile_lambda" {
  description = "The profile to use to create/destroy resources for IAM"
  type        = string
}

variable "userdb" {
    description = "User that will access the DB"
    type = string
}

variable "groupdbadmin" {
    description = "Admingroup that will access the DB"
    type = string
}

variable "availability_zones" {
  type = map
  default = {
    us-east-1      = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    us-east-2      = ["us-east-2a", "eu-east-2b", "eu-east-2c"]
    us-west-1      = ["us-west-1a", "us-west-1c"]
    us-west-2      = ["us-west-2a", "us-west-2b", "us-west-2c"]
    ca-central-1   = ["ca-central-1a", "ca-central-1b"]
    eu-west-1      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    eu-west-2      = ["eu-west-2a", "eu-west-2b"]
    eu-central-1   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    ap-south-1     = ["ap-south-1a", "ap-south-1b"]
    sa-east-1      = ["sa-east-1a", "sa-east-1c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b"]
    ap-southeast-2 = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
    ap-northeast-2 = ["ap-northeast-2a", "ap-northeast-2c"]
  }
}

variable "az_of_the_ec2" {
    description = "We will deploy in multiple ec2 but only one will host the EC2 instance"
    type = string
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
    default = "foo"
}

variable "aws_subnets" {
  description = "subnet public generated"
  type = map(any)
  default = {"foo":"bar"}
}

variable "org_id" {
  description = "Org ID"
  type = string
  default = "123456789"
}