// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resourcegroup_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}

// Create FGT VNET
// (Module vnet-fgt)
module "vnet-fgt" {
  source = "../../vnet-fgt"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name

  vnet-fgt_cidr = "172.30.0.0/20"
  admin_port    = "8443"
  admin_cidr    = "0.0.0.0/0"
}

// Create load balancers
module "xlb-fgt" {
  source = "../"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name

  backend-probe_port = "8008"

  subnet_private = {
    cidr    = module.vnet-fgt.subnet_cidrs["private"]
    id      = module.vnet-fgt.subnet_ids["private"]
    vnet_id = module.vnet-fgt.vnet["id"]
  }

  fgt-ni_ids = {
    fgt1_public  = module.vnet-fgt.fgt-active-ni_ids["port2"]
    fgt1_private = module.vnet-fgt.fgt-active-ni_ids["port3"]
    fgt2_public  = module.vnet-fgt.fgt-passive-ni_ids["port2"]
    fgt2_private = module.vnet-fgt.fgt-passive-ni_ids["port3"]
  }

  fgt-ni_ips = {
    fgt1_public  = module.vnet-fgt.fgt-active-ni_ips["port2"]
    fgt1_private = module.vnet-fgt.fgt-active-ni_ips["port3"]
    fgt2_public  = module.vnet-fgt.fgt-passive-ni_ips["port2"]
    fgt2_private = module.vnet-fgt.fgt-passive-ni_ips["port3"]
  }

  gwlb-vxlan = {
    vdi_ext  = "800"
    vdi_int  = "801"
    port_ext = "10800"
    port_int = "10801"
  }
}


