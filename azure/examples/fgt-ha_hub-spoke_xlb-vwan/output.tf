output "fgt_hub" {
  value = {
    admin        = local.admin_username
    pass         = local.admin_password
    api_key      = module.fgt_hub_config.api_key
    active_mgmt  = "https://${module.fgt_hub_vnet.fgt-active-mgmt-ip}:${local.admin_port}"
    passive_mgmt = "https://${module.fgt_hub_vnet.fgt-passive-mgmt-ip}:${local.admin_port}"
    vpn_psk      = module.fgt_hub_config.vpn_psk
  }
}

output "fgt_spoke" {
  value = {
    admin        = local.admin_username
    pass         = local.admin_password
    api_key      = module.fgt_spoke_config.api_key
    active_mgmt  = "https://${module.fgt_spoke_vnet.fgt-active-mgmt-ip}:${local.admin_port}"
    passive_mgmt = "https://${module.fgt_spoke_vnet.fgt-passive-mgmt-ip}:${local.admin_port}"
    vpn_psk      = module.fgt_spoke_config.vpn_psk
  }
}

output "vm_fgt_hub_vnet-spoke" {
  value = module.vm_fgt_hub_vnet-spoke.*.vm_name
}

output "vm_vhub_vnet-spoke" {
  value = module.vm_vhub_vnet-spoke.*.vm_name
}

output "vm_fgt_spoke_bastion-spoke" {
  value = module.vm_fgt_spoke_bastion.vm_name
}