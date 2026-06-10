variable "client_name" {
  type        = string
  description = "The name of the client for tagging resource names"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., production, staging)"
}

variable "vpc_cidr" {
  type        = string
  description = "The master CIDR block for the entire VPC network"
}

variable "availability_zones" {
  type        = list(string)
  description = "The AWS availability zones where subnets will be allocated"
}