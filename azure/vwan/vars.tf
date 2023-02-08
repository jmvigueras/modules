variable "resourcegroup_name" {}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    Deploy  = "module-azure_vhub"
    Project = "terraform-fortinet"
  }
}

variable "prefix" {
  type    = string
  default = "terraform"
}

//Region for HUB Azure deployment
variable "location" {
  type    = string
  default = "francecentral"
}

// List of VNET to connect to vHUB
variable "vhub_cidr" {
  type    = string
  default = "10.0.252.0/23"
}

// List of VNET to connect to vHUB
variable "vnet_connection" {
  type    = list(string)
  default = null
}

// VNET FGT to connect to vHUB
variable "vnet-fgt_id" {
  type    = string
  default = null
}

// VNET FGT subnets IDs
variable "subnet-fgt_ids" {
  type    = map(any)
  default = null
}

// FGT active member IP
variable "fgt-cluster_active-ip" {
  type    = string
  default = null
}

// FGT Passive member IP
variable "fgt-cluster_passive-ip" {
  type    = string
  default = null
}

variable "fgt-cluster_bgp-asn" {
  type    = string
  default = "65001"
}
