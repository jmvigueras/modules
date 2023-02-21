# GCP resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}
# GCP region
variable "region" {
  type    = string
  default = "europe-west4" #Default Region
}

variable "ncc_ips" {
  type    = list(string)
  default = null
}

variable "ncc_bgp-asn" {
  type    = string
  default = "65515"
}

variable "fgt_bgp-asn" {
  type    = string
  default = "65000"
}

variable "vpc_name" {
  type    = string
  default = null
}

variable "subnet_self_link" {
  type    = string
  default = null
}

variable "fgt_active_self_link" {
  type    = string
  default = null
}

variable "fgt_passive_self_link" {
  type    = string
  default = null
}

variable "fgt-active-ni_ip" {
  type    = string
  default = null
}

variable "fgt-passive-ni_ip" {
  type    = string
  default = null
}

variable "fgt_passive" {
  type    = bool
  default = false
}
