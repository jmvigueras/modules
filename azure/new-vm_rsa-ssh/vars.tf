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

// SSH RSA public key for KeyPair if not exists
variable "rsa-public-key" {
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
    Deploy  = "module-vms"
    Project = "terraform-fortinet"
  }
}

//For testing VMs
variable "vm_size" {
  type    = string
  default = "Standard_B1ms"
}

//For testing VMs
variable "vm_ni_ids" {
  type    = list(string)
  default = null
}

# Azure region
variable "location" {
  type    = string
  default = "europe-west4" #Default Region
}

