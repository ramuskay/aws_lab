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

variable "org_id" {
  description = "Org ID"
  type = string
  default = "123456789"
}

variable "lambda_invoke_arn" {
  description = "ARN Lambda"
  type = string
  default = "123456789"
}

variable "lambda_name" {
  description = "Name Lambda"
  type = string
  default = "123456789"
}