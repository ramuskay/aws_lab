provider "aws" {
  region = var.region
  profile = var.profile_admin
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

data "aws_organizations_organization" "org" {}

output "org_id" {
  value = data.aws_organizations_organization.org.id
}

/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                 = "./modules/vpc"
  region                           = var.region
  owner                = var.owner
  profile                           = var.profile_admin
}

/******************************************
	EC2 configuration
 *****************************************/
module "ec2" {
  source                                 = "./modules/ec2"
  region                           = var.region
  owner                = var.owner
  profile                           = var.profile_admin
  az_of_the_ec2 = var.az_of_the_ec2
  vpc_id = module.vpc.vpc_id
  aws_subnets = module.vpc.aws_subnets
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}

# /******************************************
# 	IAM configuration
#  *****************************************/
module "iam" {
  source                                 = "./modules/iam"
  region                           = var.region
  owner                = var.owner
  profile                           = var.profile_admin
  userdb = var.userdb
  groupdbadmin = var.groupdbadmin
  org_id = data.aws_organizations_organization.org.id
}

module "lambda" {
  source                                 = "./modules/lambda"
  region                           = var.region
  owner                = var.owner
  profile                           = var.profile_lambda
  org_id = data.aws_organizations_organization.org.id
  iam_role_lambda = module.iam.iam_role_lambda_arn
}
