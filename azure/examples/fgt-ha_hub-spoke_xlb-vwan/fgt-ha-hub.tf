#------------------------------------------------------------------
# Create FGT HUB 
# - FGT config
# - FGT vms
# - FGT VNet
# - LB (external and internal)
###################################################################
module "fgt_hub_config" {
  depends_on = [module.xlb, module.fgt_hub_vnet, module.rs]
  source     = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_cidrs       = module.fgt_hub_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_hub_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_hub_vnet.fgt-passive-ni_ips

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  config_fgcp    = local.hub_cluster_type == "fgcp" ? true : false
  config_fgsp    = local.hub_cluster_type == "fgsp" ? true : false
  config_hub     = true
  config_vhub    = true
  config_ars     = true
  config_vxlan   = true
  hub            = local.hub
  hub_peer_vxlan = local.hub_peer_vxlan
  vhub_peer      = module.vwan.virtual_router_ips
  rs_peer        = module.rs.rs_peer

  vpc-spoke_cidr = [module.fgt_hub_vnet.subnet_cidrs["bastion"]]
}
// Create FGT cluster as HUB-ADVPN
// (Example with a full scenario deployment with all modules)
module "fgt_hub" {
  depends_on = [module.fgt_hub_config]
  source     = "../../fgt-ha"

  prefix                   = "${local.prefix}-hub"
  location                 = local.location
  resource_group_name      = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                     = local.tags
  storage-account_endpoint = local.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : local.storage-account_endpoint

  admin_username = local.admin_username
  admin_password = local.admin_password

  fgt-active-ni_ids  = module.fgt_hub_vnet.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_hub_vnet.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_hub_config.fgt_config_1
  fgt_config_2       = module.fgt_hub_config.fgt_config_2

  fgt_passive = true
}
// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "fgt_hub_vnet" {
  source = "../../vnet-fgt_v2"

  prefix              = "${local.prefix}-hub"
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  vnet-fgt_cidr = local.hub[0]["cidr"]
  admin_port    = local.admin_port
  admin_cidr    = local.admin_cidr

  config_xlb = true // module variable to associate a public IP to fortigate's public interface (when using External LB, true means not to configure a public IP)
}
// Create load balancers
module "xlb" {
  depends_on = [module.fgt_hub_vnet]
  source     = "../../xlb"

  prefix              = local.prefix
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  config_gwlb        = local.config_gwlb
  ilb_ip             = local.ilb_ip
  backend-probe_port = local.backend-probe_port

  vnet-fgt           = module.fgt_hub_vnet.vnet
  subnet_ids         = module.fgt_hub_vnet.subnet_ids
  subnet_cidrs       = module.fgt_hub_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_hub_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_hub_vnet.fgt-passive-ni_ips
}

###########################################################################
# Deploy complete architecture with other modules used as input in module
# - module vwan
# - module vnet-fgt
# - module vnet-spoke
# - module site-spoke-to-2hubs
# - module vwan
# - module rs
############################################################################
// Module create vWAN and vHUB
module "vwan" {
  depends_on = [module.vhub_vnet-spoke, module.fgt_hub_vnet]
  source     = "../../vwan"

  prefix              = local.prefix
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  vhub_cidr              = local.vhub_cidr
  vnet_connection        = module.vhub_vnet-spoke.*.vnet_id
  vnet-fgt_id            = module.fgt_hub_vnet.vnet["id"]
  fgt-cluster_active-ip  = module.fgt_hub_vnet.fgt-active-ni_ips["private"]
  fgt-cluster_passive-ip = module.fgt_hub_vnet.fgt-passive-ni_ips["private"]
  fgt-cluster_bgp-asn    = local.hub[0]["bgp_asn_hub"]
}
// Module VNET spoke vHUB
// - This module will generate VNET spoke to connecto to vHUB 
module "vhub_vnet-spoke" {
  count  = length(local.vhub_vnet-spoke_cidrs)
  source = "../../vnet-spoke_v2"

  prefix              = "${local.prefix}-vhub-${count.index + 1}"
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  vnet_spoke_cidr = local.vhub_vnet-spoke_cidrs[count.index]
  vnet_fgt        = null
}
// Module VNET spoke VNET FGT
// - This module will generate VNET spoke to connecto to VNET FGT
// - Module will peer VNET to VNET FGT
module "fgt_hub_vnet-spoke" {
  depends_on = [module.fgt_hub_vnet]
  count      = length(local.hub_vnet-spoke_cidrs)
  source     = "../../vnet-spoke_v2"

  prefix              = "${local.prefix}-fgt-${count.index + 1}"
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  vnet_spoke_cidr = local.hub_vnet-spoke_cidrs[count.index]
  vnet_fgt        = module.fgt_hub_vnet.vnet
}
// Create Azure Router Servers
module "rs" {
  depends_on = [module.fgt_hub_vnet-spoke, module.fgt_hub_vnet]
  source     = "../../routeserver"

  prefix              = local.prefix
  location            = local.location
  resource_group_name = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                = local.tags

  subnet_ids   = [for subnet_id in module.fgt_hub_vnet-spoke : subnet_id.subnet_ids["routeserver"]]
  fgt_bgp-asn  = local.hub[0]["bgp_asn_hub"]
  fgt1_peer-ip = module.fgt_hub_vnet.fgt-active-ni_ips["private"]
  fgt2_peer-ip = module.fgt_hub_vnet.fgt-passive-ni_ips["private"]
}
// Create virtual machines
module "vm_fgt_hub_vnet-spoke" {
  count  = length(module.fgt_hub_vnet-spoke)
  source = "../../new-vm_rsa-ssh_v2"

  prefix                   = "${local.prefix}-spoke-fgt-${count.index + 1}"
  location                 = local.location
  resource_group_name      = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                     = local.tags
  storage-account_endpoint = local.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : local.storage-account_endpoint
  admin_username           = local.admin_username
  rsa-public-key           = trimspace(tls_private_key.ssh.public_key_openssh)

  subnet_id   = module.fgt_hub_vnet-spoke[count.index].subnet_ids["subnet_1"]
  subnet_cidr = module.fgt_hub_vnet-spoke[count.index].subnet_cidrs["subnet_1"]
}
// Create VM in spoke vNet
module "vm_vhub_vnet-spoke" {
  count  = length(module.vhub_vnet-spoke)
  source = "../../new-vm_rsa-ssh_v2"

  prefix                   = "${local.prefix}-spoke-vhub-${count.index + 1}"
  location                 = local.location
  resource_group_name      = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  tags                     = local.tags
  storage-account_endpoint = local.storage-account_endpoint == null ? azurerm_storage_account.storageaccount[0].primary_blob_endpoint : local.storage-account_endpoint
  admin_username           = local.admin_username
  rsa-public-key           = trimspace(tls_private_key.ssh.public_key_openssh)

  subnet_id   = module.vhub_vnet-spoke[count.index].subnet_ids["subnet_1"]
  subnet_cidr = module.vhub_vnet-spoke[count.index].subnet_cidrs["subnet_1"]
}




