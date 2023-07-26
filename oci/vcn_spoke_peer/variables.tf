variable "compartment_ocid" {}

variable "region" {
  type    = string
  default = "eu-frankfurt-1"
}

variable "region_ad_1" {
  type    = string
  default = "1"
}

variable "region_ad_2" {
  type    = string
  default = "2"
}

# OCI resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "sufix" {
  type    = string
  default = "1"
}

variable "tags" {
  description = "Resouce Tags"
  type        = map(string)
  default = {
    owner   = "terraform"
    project = "terraform-deploy"
  }
}

## VCN and SUBNET ADDRESSESS
variable "vcn_cidr" {
  default = "172.20.0.0/24"
}

variable "fgt_vcn_lpg_id" {
  type    = string
  default = null
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}