variable "storage-account_endpoint" {
  type    = string
  default = null
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "admin_password" {
  type    = string
  default = null
}

variable "prefix" {
  type    = string
  default = "terraform"
}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    Deploy  = "module-faz"
    Project = "terraform-fortinet"
  }
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "faz_extra-config" {
  type    = string
  default = ""
}

variable "faz_ni_ids" {
  type    = map(string)
  default = null
}

variable "faz_ni_ips" {
  type    = map(string)
  default = null
}

variable "subnet_cidrs" {
  type    = map(string)
  default = null
}

// AMI
variable "faz_sku" {
  type = map(string)
  default = {
    payg = ""
    byol = "fortinet-fortianalyzer"
  }
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

variable "faz_offer" {
  type    = string
  default = "fortinet-fortianalyzer"
}

variable "faz_version" {
  type    = string
  default = "latest"
}

variable "size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "faz_ni_0" {
  type    = string
  default = "public"
}

variable "faz_ni_1" {
  type    = string
  default = "private"
}

variable "public_port" {
  type    = string
  default = "port1"
}
variable "private_port" {
  type    = string
  default = "port2"
}

// SSH RSA public key for KeyPair if not exists
variable "rsa-public-key" {
  type    = string
  default = null
}

variable "api_key" {
  type    = string
  default = null
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  type    = string
  default = "payg"
}

// license file for the active fgt
variable "license_file" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/licenseFMG.lic"
}