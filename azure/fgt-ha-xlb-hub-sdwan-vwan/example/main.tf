###################################################################
# Example of use of module
###################################################################
// Create FGT cluster as HUB-ADVPN
// (Example with a full scenario deployment with all modules)
module "fgt-ha" {
  depends_on = [module.xlb, module.vnet-fgt, module.rs]
  source     = "../"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint

  adminusername = var.adminusername
  adminpassword = var.adminpassword
  admin_port    = var.admin_port
  admin_cidr    = var.admin_cidr

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  fgt-subnet_cidrs = module.vnet-fgt.subnet_cidrs
  fgt-active-ni_ids = [
    module.vnet-fgt.fgt-active-ni_ids["port1"],
    module.vnet-fgt.fgt-active-ni_ids["port2"],
    module.vnet-fgt.fgt-active-ni_ids["port3"]
  ]
  fgt-passive-ni_ids = [
    module.vnet-fgt.fgt-passive-ni_ids["port1"],
    module.vnet-fgt.fgt-passive-ni_ids["port2"],
    module.vnet-fgt.fgt-passive-ni_ids["port3"]
  ]
  gwlb_ip         = module.xlb.gwlb_ip // add vxlan config to GWLB
  rs_peers        = module.rs.rs_peers // add BGP config to AzureRouterServer
  rs_bgp-asn      = module.rs.rs_bgp-asn // BGP ASN AzureRouterServer
  vhub_peer       = module.vwan.virtual_router_ips // add BGP config to vHUB
  hub             = var.hub // add ADVPN HUB config
  hub-peer_vxlan  = var.hub-peer_vxlan // add vxlan connection to other HUB
  spoke_bgp-asn   = var.spoke_bgp-asn // BGP ASN spokes
  spoke_cidr_vnet = "172.16.0.0/12" // Complete CIDR range VNETs in Azure
}

###########################################################################
# Deploy complete architecture with other modules used as input in module
# - module vwan
# - module vnet-fgt
# - module vnet-spoke
# - module site-spoke-to-2hubs
# - module vwan
# - module xlb-fgt
# - module rs
############################################################################

// Module create vWAN and vHUB
module "vwan" {
  depends_on = [module.vnet-spoke-vhub, module.vnet-fgt]
  source     = "../../vwan"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet_connection        = module.vnet-spoke-vhub.vnet_ids
  vnet-fgt_id            = module.vnet-fgt.vnet["id"]
  fgt-cluster_active-ip  = module.vnet-fgt.fgt-active-ni_ips["port3"]
  fgt-cluster_passive-ip = module.vnet-fgt.fgt-passive-ni_ips["port3"]
  fgt-cluster_bgp-asn    = var.hub["bgp-asn"]
}

// Module VNET spoke vHUB
// - This module will generate VNET spoke to connecto to vHUB 
module "vnet-spoke-vhub" {
  source = "../../vnet-spoke"

  prefix             = "${var.prefix}-vhub"
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-spoke_cidrs = ["172.30.18.0/23"]
  vnet-fgt         = null
}

// Module VNET spoke VNET FGT
// - This module will generate VNET spoke to connecto to VNET FGT
// - Module will peer VNET to VNET FGT
module "vnet-spoke-fgt" {
  depends_on = [module.vnet-fgt]
  source     = "../../vnet-spoke"

  prefix             = "${var.prefix}-fgt"
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-spoke_cidrs = ["172.30.16.0/23"]
  vnet-fgt = {
    id   = module.vnet-fgt.vnet["id"]
    name = module.vnet-fgt.vnet["name"]
  }
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
  admin_port    = var.admin_port
  admin_cidr    = var.admin_cidr
}

// Create load balancers
module "xlb" {
  depends_on = [module.vnet-fgt]
  source     = "../../xlb-fgt"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

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
}

// Create load balancers
module "rs" {
  depends_on = [module.vnet-spoke-fgt, module.vnet-fgt]
  source     = "../../routeserver"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  subnet_ids   = module.vnet-spoke-fgt.subnet_ids["routeserver"]
  fgt_bgp-asn  = var.hub["bgp-asn"]
  fgt1_peer-ip = module.vnet-fgt.fgt-active-ni_ips["port3"]
  fgt2_peer-ip = module.vnet-fgt.fgt-passive-ni_ips["port3"]
}


// Create spoke site 1
module "site1" {
  depends_on = [module.fgt-ha]
  source     = "../../site-spoke-to-2hubs"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  adminusername = var.adminusername
  adminpassword = var.adminpassword
  admin_port    = var.admin_port
  admin_cidr    = var.admin_cidr

  site = {
    site_id   = "1"
    bgp-asn   = var.spoke_bgp-asn
    cidr      = "192.168.0.0/24"
    advpn-ip1 = cidrhost(var.hub["advpn-net"], 10)
    advpn-ip2 = "10.10.20.10"
  }

  hub1 = {
    bgp-asn     = var.hub["bgp-asn"]
    public-ip1  = module.xlb.elb_public-ip
    advpn-ip1   = cidrhost(var.hub["advpn-net"], 1)
    hck-srv-ip1 = module.vnet-spoke-fgt.ni_ips["subnet1"][0]
    hck-srv-ip2 = module.vnet-spoke-fgt.ni_ips["subnet2"][0]
    cidr        = "172.30.0.0/20"
    advpn-psk   = module.fgt-ha.advpn-ipsec-psk
  }
}

// Create virtual machines
module "vms" {
  source = "../../vm"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint
  adminusername            = var.adminusername
  adminpassword            = var.adminpassword

  vm_ni_ids = [
    module.vnet-spoke-fgt.ni_ids["subnet1"][0],
    module.vnet-spoke-fgt.ni_ids["subnet2"][0],
    module.vnet-spoke-vhub.ni_ids["subnet1"][0],
    module.vnet-spoke-vhub.ni_ids["subnet2"][0]
  ]
}


###################################################################
# Create necesary resources if not provided
###################################################################

// Create storage account if not provided
resource "random_id" "randomId" {
  count       = var.storage-account_endpoint == null ? 1 : 0
  byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
  count                    = var.storage-account_endpoint == null ? 1 : 0
  name                     = "stgra${random_id.randomId[count.index].hex}"
  resource_group_name      = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resourcegroup_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}



