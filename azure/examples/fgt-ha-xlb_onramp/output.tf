output "fgt_spoke" {
  value = {
    admin        = var.admin_username
    pass         = var.admin_password
    api_key      = module.fgt_spoke_config.api_key
    active_mgmt  = "https://${module.fgt_spoke_vnet.fgt-active-mgmt-ip}:${var.admin_port}"
    passive_mgmt = "https://${module.fgt_spoke_vnet.fgt-passive-mgmt-ip}:${var.admin_port}"
    vpn_psk      = module.fgt_spoke_config.vpn_psk
  }
}

