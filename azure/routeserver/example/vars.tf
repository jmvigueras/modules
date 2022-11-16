// Azure configuration for Terraform providers
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

// Resource group name
variable "resourcegroup_name" {
  type    = string
  default = null
}

// Azure resourcers prefix description added in name
variable "prefix" {
  type    = string
  default = "module-rs"
}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    Deploy  = "module-vnet-spoke"
    Project = "terraform-fortinet"
  }
}

// Region for deployment
variable "location" {
  type    = string
  default = "francecentral"
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "fgt_bgp-asn" {
  type    = string
  default = "65001"
}

variable "fgt1_peer-ip" {
  type    = string
  default = "172.31.3.10"
}

variable "fgt2_peer-ip" {
  type    = string
  default = "172.31.3.11"
}

// Variable need for module vnet-spoke
variable "vnet-spoke_cidrs" {
  type = list(string)
  default = [
    "172.30.16.0/23",
    "172.30.18.0/23"
  ]
}







