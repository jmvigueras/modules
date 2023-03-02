###################################################################
# Deploy VNETs spoke to VNET FGT
# - It will create peering between VNET spoke and VNET FGT
###################################################################

// Create VNETs spoke
module "vnet-spoke" {
  depends_on = [module.vnet-fgt]
  source     = "../"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name
  tags                = var.tags

  vnet-spoke_cidrs = var.vnet-spoke_cidrs
  # Peer with VNET vnet-fgt
  vnet-fgt = {
    id   = module.vnet-fgt.vnet["id"]
    name = module.vnet-fgt.vnet["name"]
  }
}

// Deploy VNET, Subnets, Interfaces and NSG for Fortigate cluster
// - Need for peering with VNET FGT if not provided as variable
module "vnet-fgt" {
  source = "../../vnet-fgt"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name

  vnet-fgt_cidr = var.vnet-fgt_cidr
  admin_port    = var.admin_port
  admin_cidr    = var.admin_cidr
}

###################################################################
# Create necesary resources if not provided
###################################################################

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}