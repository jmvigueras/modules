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

variable "peer_bgp-asn" {
  type    = string
  default = "65011"
}

variable "peer_ip" {
  type    = list(string)
  default = ["172.29.0.0,172.29.0.0,"]
}

variable "tgw_inside_cidr" {
  type    = list(string)
  default = ["169.254.100.0/29", "169.254.101.0/29"]
}

variable "tgw_cidr" {
  type    = list(string)
  default = ["172.29.10.0/24"]
}

variable "tgw_id" {
  type    = string
  default = null
}

variable "vpc_tgw-att_id" {
  type    = string
  default = null
}

variable "rt_propagation_id" {
  type    = list(string)
  default = null
}