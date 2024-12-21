provider "aws" {
  region  = var.region
  profile = var.profile["admin"]
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
  source             = "./modules/vpc"
  region             = var.region
  owner              = var.owner
  profile            = var.profile["admin"]
  availability_zones = var.availability_zones
}

/******************************************
	EC2 configuration
 *****************************************/
module "ec2" {
  source        = "./modules/ec2"
  region        = var.region
  owner         = var.owner
  profile       = var.profile["admin"]
  az_of_the_ec2 = var.az_of_the_ec2
  vpc_id        = module.vpc.vpc_id
  aws_subnets   = module.vpc.aws_subnets
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}

# /******************************************
# 	IAM configuration
#  *****************************************/
module "iam" {
  source       = "./modules/iam"
  region       = var.region
  owner        = var.owner
  profile      = var.profile["admin"]
  userdb       = var.userdb
  groupdbadmin = var.groupdbadmin
  org_id       = data.aws_organizations_organization.org.id
}

# /******************************************
# 	Lambda configuration
#  *****************************************/
module "lambda" {
  source          = "./modules/lambda"
  region          = var.region
  owner           = var.owner
  profile         = var.profile["lambda"]
  org_id          = data.aws_organizations_organization.org.id
  iam_role_lambda = module.iam.iam_role_lambda_arn
  list_lambda     = var.list_lambda
}

# /******************************************
# 	API Gateway configuration
#  *****************************************/
module "api-gateway" {
  source  = "./modules/api-gateway"
  region  = var.region
  owner   = var.owner
  profile = var.profile["api_gateway"]
  org_id  = data.aws_organizations_organization.org.id
  lambda  = module.lambda.lambda_object
}


# /******************************************
# 	Step Functions configuration
#  *****************************************/
module "step_functions" {
  source  = "./modules/step_functions"
  region  = var.region
  owner   = var.owner
  profile = var.profile["step_function"]
  org_id  = data.aws_organizations_organization.org.id
  lambda  = module.lambda.lambda_object
}