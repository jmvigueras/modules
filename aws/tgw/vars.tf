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

variable "tgw_bgp-asn" {
  type    = string
  default = "64515"
}

variable "tgw_cidr" {
  type    = list(string)
  default = ["172.29.10.0/24"]
}
