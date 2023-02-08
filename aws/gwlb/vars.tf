##############################################################################################################
#
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment -
#
##############################################################################################################
# Prefix for all resources created for this deployment in AWS
variable "prefix" {
  description = "Provide a common tag prefix value that will be used in the name tag for all resources"
  default     = "terraform"
}

variable "region" {
  type = map(any)
  default = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
}

variable "subnet_ids" {
  type    = list(string)
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "backend_port" {
  type    = string
  default = "8008"
}

variable "backend_protocol" {
  type    = string
  default = "HTTP"
}

variable "backend_interval" {
  type    = number
  default = 10
}