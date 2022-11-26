#--------------------------------------------------------------------------------------
# Example of use of module
# - it will deploy fortigate (FGT) cluster as site spoke to HUB (configure "ha = true" in site var definition for FGT HA)
# - it will use another module to create necessary VNET
# - it will use another module to create VM bastion for testing
#--------------------------------------------------------------------------------------

// Create FGT cluster as HUB SDWAN site
module "fgt-site-ha" {
  depends_on = [module.vnet-fgt]
  source     = "github.com/jmvigueras/modules//azure/fgt-ha-spoke-sdwan"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint

  adminusername  = var.adminusername
  adminpassword  = var.adminpassword
  admin_port     = var.admin_port
  admin_cidr     = "${chomp(data.http.my-public-ip.body)}/32"
  rsa-public-key = chomp(tls_private_key.ssh-rsa.public_key_openssh)

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  fgt-subnet_cidrs = module.vnet-fgt.subnet_cidrs

  hubs = var.hubs
  site = var.site

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
}

#--------------------------------------------------------------------------------------
# Deploy complete architecture with other modules used as input in module
# - module vnet-fgt (../../vnet-fgt)
# - module vm (../../vm)
#--------------------------------------------------------------------------------------

// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "vnet-fgt" {
  source = "github.com/jmvigueras/modules//azure/vnet-fgt"

  prefix             = var.prefix
  location           = var.location
  resourcegroup_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags               = var.tags

  vnet-fgt_cidr = var.site["cidr"]
  admin_port    = var.admin_port
  admin_cidr    = "${chomp(data.http.my-public-ip.body)}/32"
}

// Create virtual machines
// - this module will create a test VM in VNET spoke to FGT site
module "vm" {
  source = "github.com/jmvigueras/modules//azure/vm"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint
  adminusername            = var.adminusername
  rsa-public-key           = chomp(tls_private_key.ssh-rsa.public_key_openssh)

  vm_ni_ids = [
    module.vnet-fgt.bastion-ni_id
  ]
}

#--------------------------------------------------------------------------------------
# Create necesary resources if not provided
#--------------------------------------------------------------------------------------

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

data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}

resource "tls_private_key" "ssh-rsa" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh-rsa.private_key_pem
  filename        = "./ssh-key.pem"
  file_permission = "0600"
}



