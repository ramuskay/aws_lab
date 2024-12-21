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

variable "availability_zones" {
  type = map(any)
}