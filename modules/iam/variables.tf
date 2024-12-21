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

variable "userdb" {
  description = "User that will access the DB"
  type        = string
}

variable "groupdbadmin" {
  description = "Admingroup that will access the DB"
  type        = string
}

variable "org_id" {
  description = "Org ID"
  type        = string
}