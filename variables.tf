variable "project" {
  description = "Project Name"
  type        = string
}

variable "availability_zones" {
  description = "A comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  type        = list(any)
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  type        = list(any)
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  type        = list(any)
}

variable "frontend_repo" {
  description = "Front End Repository"
  type        = string
}

variable "backend_repo" {
  description = "Back End Repository"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
}
