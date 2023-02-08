variable "storage-account_endpoint" {}
variable "resourcegroup_name" {
  type    = string
  default = null
}

variable "adminusername" {}
variable "adminpassword" {}

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

# Azure region
variable "location" {
  type    = string
  default = "europe-west4" #Default Region
}

// HTTPS Port
variable "admin_port" {
  type    = string
  default = "8443"
}

// HTTPS Port
variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

//  For HA, choose instance size that support 4 nics at least
//  Check : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes
variable "size" {
  type    = string
  default = "Standard_F4"
}

variable "license_type" {
  default = "payg"
}

// license file for fgt
variable "license-site" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/license-site.lic"
}

// enable accelerate network, either true or false, default is false
// Make the the instance choosed supports accelerated networking.
// Check: https://docs.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances
variable "accelerate" {
  default = "false"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

// BYOL sku: fortinet_fg-vm
// PAYG sku: fortinet_fg-vm_payg_2022
variable "fgtsku" {
  type = map(any)
  default = {
    byol = "fortinet_fg-vm"
    payg = "fortinet_fg-vm_payg_2022"
  }
}

variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}

// FOS version
variable "fgtversion" {
  type    = string
  default = "7.2.2"
}