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
  type        = string
}

variable "lambda" {
  description = "Name Lambda"
  type = map(object({
    name       = string
    arn        = string
    invoke_arn = string
  }))
}