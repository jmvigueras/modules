##################################################################
# VMs
# (Module will create as many VM as NI defined in vm_nis)
##################################################################
// Create virtual machines
module "vms" {
  source = "../"

  prefix                   = var.prefix
  location                 = var.location
  resourcegroup_name       = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  tags                     = var.tags
  storage-account_endpoint = var.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : var.storage-account_endpoint
  adminusername            = "azureadmin"
  adminpassword             = "my-secret-pass#"

  vm_ni_ids = [
    "/subscriptions/xxxxx/resourceGroups/module-vnet-spoke-rg/providers/Microsoft.Network/networkInterfaces/subnet-1_ni-1",
    "/subscriptions/xxxxx/resourceGroups/module-vnet-spoke-rg/providers/Microsoft.Network/networkInterfaces/subnet-1_ni-2"
  ]
  vm_size = "Standard_B1ms"
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
