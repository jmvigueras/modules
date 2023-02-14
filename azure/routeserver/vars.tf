variable "resource_group_name" {
  type    = string
  default = null
}

# Azure resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    Deploy  = "module-vnet-spoke"
    Project = "terraform-fortinet"
  }
}

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



