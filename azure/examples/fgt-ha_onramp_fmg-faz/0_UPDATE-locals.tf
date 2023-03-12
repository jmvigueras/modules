locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  resource_group_name      = null // a new resource group will be created if null
  location                 = "francecentral"
  storage-account_endpoint = null               // a new resource group will be created if null
  prefix                   = "demo-fgt-faz-fmg" // prefix added to all resources created

  admin_username = "azureadmin"
  admin_password = "Terraform123#"

  tags = {
    Deploy  = "demo-fgt-faz-fmg"
    Project = "terraform-fortinet"
  }

  #-----------------------------------------------------------------------------------------------------
  # FGT
  #-----------------------------------------------------------------------------------------------------
  fgt_license_type = "payg"
  fgt_size         = "Standard_F4"
  fgt_version      = "latest"

  admin_port = "8443"
  admin_cidr = "${chomp(data.http.my-public-ip.body)}/32"

  fgt_vnet_cidr = "172.30.0.0/23"

  #-----------------------------------------------------------------------------------------------------
  # FAZ and FMG
  #-----------------------------------------------------------------------------------------------------
  faz_license_type = "byol"
  faz_license_file = "./licenses/licenseFAZ.lic"
  fmg_license_type = "byol"
  fmg_license_file = "./licenses/licenseFMG.lic"
}





#-----------------------------------------------------------------------
# Necessary variables
#-----------------------------------------------------------------------
data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${local.prefix}-ssh-key.pem"
  file_permission = "0600"
}

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "vpn_psk" {
  length  = 30
  special = false
  numeric = true
}

// Create storage account if not provided
resource "random_id" "randomId" {
  count       = local.storage-account_endpoint == null ? 1 : 0
  byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
  count                    = local.storage-account_endpoint == null ? 1 : 0
  name                     = "stgra${random_id.randomId[count.index].hex}"
  resource_group_name      = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  location                 = local.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = local.tags
}

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = local.resource_group_name == null ? 1 : 0
  name     = "${local.prefix}-rg"
  location = local.location

  tags = local.tags
}