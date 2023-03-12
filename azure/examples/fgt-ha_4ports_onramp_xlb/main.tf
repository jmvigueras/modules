#------------------------------------------------------------------
# Create FGT HUB 
# - Create cluster FGCP config
# - Create FGCP instances
# - Create vNet
# - Create LB
#------------------------------------------------------------------
module "fgt_config" {
  source = "../../fgt-config_4ports"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_cidrs       = module.fgt_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_vnet.fgt-passive-ni_ips

  # Config for SDN connector
  # - API calls (optional)
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  resource_group_name  = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  # -

  config_fgcp = true

  vpc-spoke_cidr = [module.fgt_vnet.subnet_cidrs["bastion"]]
}

// Create FGT cluster spoke
// (Example with a full scenario deployment with all modules)
module "fgt" {
  source = "../../fgt-ha_4ports"

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

  fgt_ni_0 = "public"
  fgt_ni_1 = "private"
  fgt_ni_2 = "mgmt"
  fgt_ni_3 = "ha"
}

// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "fgt_vnet" {
  source = "../../vnet-fgt_4ports"

  prefix              = local.prefix
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  vnet-fgt_cidr = local.fgt_vnet_cidr
  admin_port    = local.admin_port
  admin_cidr    = local.admin_cidr
}

// Create load balancers
module "xlb" {
  depends_on = [module.fgt_vnet]
  source     = "../../xlb"

  prefix              = local.prefix
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  config_gwlb        = local.config_gwlb
  ilb_ip             = local.ilb_ip
  backend-probe_port = local.backend-probe_port

  vnet-fgt           = module.fgt_vnet.vnet
  subnet_ids         = module.fgt_vnet.subnet_ids
  subnet_cidrs       = module.fgt_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_vnet.fgt-passive-ni_ips
}
