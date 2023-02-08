###################################################################
# Example of use of module
###################################################################
// Create FGT cluster as HUB-ADVPN
// (Example with a full scenario deployment with all modules)
module "fgt-ha" {
  depends_on = [module.vnet-fgt]
  source     = "github.com/jmvigueras/modules//azure/fgt-ha-sdn"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint

  adminusername = local.adminusername
  adminpassword = local.adminpassword
  admin_port    = local.admin_port
  admin_cidr    = var.admin_cidr

  # Needed for SDN connector HA
  subscription_id        = var.subscription_id
  client_id              = var.client_id
  client_secret          = var.client_secret
  tenant_id              = var.tenant_id
  fgt-active-ni_names    = module.vnet-fgt.fgt-active-ni_names
  fgt-passive-ni_names   = module.vnet-fgt.fgt-active-ni_names
  cluster-public-ip_name = module.vnet-fgt.cluster-public-ip_name
  vnet-spoke-rt          = "${var.prefix}-vnet-spoke-rt"

  # Subnets details for VNET FGT (mandatory)
  fgt-subnet_cidrs = module.vnet-fgt.subnet_cidrs
  # FGT active network interfaces (mandatory)
  fgt-active-ni_ids = [
    module.vnet-fgt.fgt-active-ni_ids["port1"],
    module.vnet-fgt.fgt-active-ni_ids["port2"],
    module.vnet-fgt.fgt-active-ni_ids["port3"]
  ]
  # FGT passive network interfaces (mandatory if you set ha=true in site definition in vars_hubs.tf)
  fgt-passive-ni_ids = [
    module.vnet-fgt.fgt-passive-ni_ids["port1"],
    module.vnet-fgt.fgt-passive-ni_ids["port2"],
    module.vnet-fgt.fgt-passive-ni_ids["port3"]
  ]
  # Complete CIDR range VNets in Azure
  spoke_cidr_vnet = local.spoke_cidr_vnet
}

###########################################################################
# Deploy complete architecture with other modules used as input in module
# - module vnet-fgt
# - module vnet-spoke
############################################################################

// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "vnet-fgt" {
  source = "github.com/jmvigueras/modules//azure/vnet-fgt"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-fgt_cidr = local.vnet-fgt_cidr
  admin_port    = local.admin_port
  admin_cidr    = var.admin_cidr
}

// Module VNET spoke VNET FGT
// - This module will generate VNET spoke to connecto to VNET FGT
// - Module will peer VNET to VNET FGT
module "vnet-spoke-fgt" {
  depends_on = [module.vnet-fgt]
  source     = "github.com/jmvigueras/modules//azure/vnet-spoke"

  prefix             = "${var.prefix}-fgt"
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-spoke_cidrs = local.vnet-spoke_cidrs
  vnet-fgt = {
    id   = module.vnet-fgt.vnet["id"]
    name = module.vnet-fgt.vnet["name"]
  }
}

// Create virtual machines
module "vms" {
  source = "github.com/jmvigueras/modules//azure/vm"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint
  adminusername            = local.adminusername
  adminpassword            = local.adminpassword

  vm_ni_ids = [
    module.vnet-spoke-fgt.ni_ids["subnet1"][0],
    module.vnet-spoke-fgt.ni_ids["subnet2"][0]
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




