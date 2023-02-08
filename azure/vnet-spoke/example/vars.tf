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
  default = "module-vnet-spoke"
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

// List of CIDR ranges for vnets spoke (it will create as much VNET as ranges)
// (module will deploy as much VNETs as CIDRS appears)
variable "vnet-spoke_cidrs" {
  type = list(string)
  default = [
    "172.30.16.0/23",
    "172.30.18.0/23"
  ]
}

// VNET ID of FGT VNET for peering
variable "vnet-fgt" {
  type = map(any)
  default = {
    name = "vnet-fgt",
    id   = "vnet-id"
  }
}

########################################################
# Necesary for module vnet-fgt
// Cidr range for VNET FGT
variable "vnet-fgt_cidr" {
  default = "172.30.0.0/20"
}

variable "accelerate" {
  default = "false"
}

// HTTPS Port
variable "admin_port" {
  type    = string
  default = "8443"
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}






