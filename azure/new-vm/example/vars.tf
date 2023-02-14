// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "storage-account_endpoint" {
  type    = string
  default = null
}

variable "resourcegroup_name" {
  type    = string
  default = null
}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    Deploy  = "module-vms"
    Project = "terraform-fortinet"
  }
}

# Azure resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

# Azure region
variable "location" {
  type    = string
  default = "francecentral"
}