// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}

// Create FGT VNET
// (Module vnet-fgt)
module "vnet-fgt" {
  source = "../../vnet-fgt"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name

  vnet-fgt_cidr = "172.30.0.0/20"
  admin_port    = "8443"
  admin_cidr    = "0.0.0.0/0"
}

// Create load balancers
module "xlb-fgt" {
  source = "../"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name

  backend-probe_port = "8008"

  vnet-fgt           = module.vnet-fgt.vnet
  subnet_ids         = module.vnet-fgt.subnet_ids
  subnet_cidrs       = module.vnet-fgt.subnet_cidrs
  fgt-active-ni_ips  = module.vnet-fgt.fgt-active-ni_ips
  fgt-passive-ni_ips = module.vnet-fgt.fgt-passive-ni_ips

  config_gwlb = true

  gwlb_vxlan = {
    vdi_ext  = "800"
    vdi_int  = "801"
    port_ext = "10800"
    port_int = "10801"
  }
  // (Optional - List of listeners)
  elb_listeners = {
    "80"   = "Tcp"
    "443"  = "Tcp"
    "500"  = "Udp"
    "4500" = "Udp"
    "4789" = "Udp"
    "6379" = "Tcp"
    "6443" = "Tcp"
  }
}


