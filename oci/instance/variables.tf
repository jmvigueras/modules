variable "compartment_ocid" {}

// Region
variable "region" {
  type    = string
  default = "eu-frankfurt-1"
}
variable "region_ad" {
  type    = string
  default = "1"
}
// OCI resourcers description
variable "prefix" {
  type    = string
  default = "terraform"
}
variable "sufix" {
  type    = string
  default = "1"
}
// Resources Tags
variable "tags" {
  description = "Resouce Tags"
  type        = map(string)
  default = {
    owner   = "terraform"
    project = "terraform-deploy"
  }
}
// VM
variable "shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}
variable "ocpus" {
  type    = number
  default = 1
}
variable "memory_in_gbs" {
  type    = number
  default = 2
}
// SSH RSA public key for KeyPair if not exists
variable "authorized_keys" {
  type    = list(string)
  default = null
}
variable "subnet_id" {
  type    = string
  default = null
}
