// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resourcegroup_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}

// Deploy VNET, Subnets, Interfaces and NSG for Fortigate cluster
module "vnet-fgt" {
  source = "../"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                = var.tags

  vnet-fgt_cidr = "172.30.0.0/20" //default value if not set
  admin_port    = "8443"          //default value if not set
  admin_cidr    = "0.0.0.0/0"     //default value if not set
  accelerate    = true            //default value if not set

  config_xlb = true
}