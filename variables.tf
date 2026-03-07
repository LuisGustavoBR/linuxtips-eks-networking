variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "Main CIDR of the VPC"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "List of additional VPC CIDRs"
  default     = []
}

variable "public_subnets" {
  description = "List of VPC Public Subnets"
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "List of VPC Private Subnets"
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}

variable "database_subnets" {
  description = "List of VPC Database Subnets"
  default     = []
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}