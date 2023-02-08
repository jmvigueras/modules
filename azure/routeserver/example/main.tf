// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resourcegroup_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}

// Create VNET SPOKES
// (Module vnet-spoke, if VNET are deployed this will be no necessary)
module "vnet-spoke" {
  source = "../../vnet-spoke"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-spoke_cidrs = var.vnet-spoke_cidrs
}

// Create load balancers
module "rs" {
  source = "../"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name

  subnet_ids   = module.vnet-spoke.subnet_ids["routeserver"]
  fgt_bgp-asn  = "65001"
  fgt1_peer-ip = "172.31.3.10"
  fgt2_peer-ip = "172.31.3.11"
}


