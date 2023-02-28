// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "resource_group_name" {
  type    = string
  default = null
}

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
