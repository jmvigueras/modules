#------------------------------------------------------------------
# Create FGT 
# - Create cluster FGCP config
# - Create FGCP instances
# - Create vNet
# - Create LB
#------------------------------------------------------------------
module "fgt_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_cidrs       = module.fgt_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_vnet.fgt-passive-ni_ips

  # Config for SDN connector
  # - API calls
  subscription_id     = var.subscription_id
  client_id           = var.client_id
  client_secret       = var.client_secret
  tenant_id           = var.tenant_id
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  # - HA failover
  route_table          = "${local.prefix}-rt-default"
  cluster_pip          = module.fgt_vnet.fgt-active-public-name
  fgt-active-ni_names  = module.fgt_vnet.fgt-active-ni_names
  fgt-passive-ni_names = module.fgt_vnet.fgt-passive-ni_names
  # -

  config_fgcp = true

  vpc-spoke_cidr = [module.fgt_vnet.subnet_cidrs["bastion"]]
}

// Create FGT cluster spoke
// (Example with a full scenario deployment with all modules)
module "fgt" {
  source = "../../fgt-ha"

  prefix                   = local.prefix
  location                 = local.location
  resource_group_name      = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                     = local.tags
  storage-account_endpoint = local.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : local.storage-account_endpoint

  admin_username = local.admin_username
  admin_password = local.admin_password

  fgt-active-ni_ids  = module.fgt_vnet.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_vnet.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_config.fgt_config_1
  fgt_config_2       = module.fgt_config.fgt_config_2

  fgt_passive  = true
  license_type = local.license_type
  fgt_version  = local.fgt_version
  size         = local.fgt_size
}

// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "fgt_vnet" {
  source = "../../vnet-fgt"

  prefix              = local.prefix
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  vnet-fgt_cidr = local.fgt_vnet_cidr
  admin_port    = local.admin_port
  admin_cidr    = local.admin_cidr
}

#--------------------------------------------------------------------------------
# Create route table default (example of route table)
#--------------------------------------------------------------------------------
// Route-table definition
resource "azurerm_route_table" "rt-default" {
  name                = "${local.prefix}-rt-default"
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name

  disable_bgp_route_propagation = false

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.fgt_vnet.fgt-active-ni_ips["private"]
  }
}

