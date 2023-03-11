// Azure configuration for Terraform providers
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

// Resource group name
variable "resource_group_name" {
  type    = string
  default = null
}

// Azure resourcers prefix description added in name
variable "prefix" {
  type    = string
  default = "module-xlb"
}

// Azure resourcers tags
variable "tags" {
  type = map(any)
  default = {
    Deploy  = "module-xlb"
    Project = "terraform-fortinet"
  }
}

// Region for deployment
variable "location" {
  type    = string
  default = "francecentral"
}