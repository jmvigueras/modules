###################################################################
# Example of use of module
###################################################################

module "vwan" {
  depends_on = [module.vnet-spoke, module.vnet-fgt]
  source     = "../"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet_connection        = module.vnet-spoke.vnet_ids
  vnet-fgt_id            = module.vnet-fgt.vnet["id"]
  subnet-fgt_ids         = module.vnet-fgt.subnet_ids
  fgt-cluster_active-ip  = module.vnet-fgt.fgt-active-ni_ips["port3"]
  fgt-cluster_passive-ip = module.vnet-fgt.fgt-passive-ni_ips["port3"]
  fgt-cluster_bgp-asn    = "65001"
}

// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "vnet-fgt" {
  source = "../../vnet-fgt"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-fgt_cidr = "172.30.0.0/20"
  admin_port    = "8443"
  admin_cidr    = "0.0.0.0/0"
}

// Module VNET spoke
// - This module will generate VNET spoke to connecto to vHUB 
// - default will create 2 VNETs
module "vnet-spoke" {
  source = "../../vnet-spoke"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-fgt = null
}

###################################################################
# Create necesary resources if not provided
###################################################################

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resourcegroup_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}



