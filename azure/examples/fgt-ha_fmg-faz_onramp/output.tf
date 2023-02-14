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

output "faz" {
  value = {
    faz_mgmt = "https://${module.fgt_spoke_vnet.faz_public-ip}"
    faz_pass = var.admin_password
  }
}

output "fmg" {
  value = {
    fmg_mgmt = "https://${module.fgt_spoke_vnet.fmg_public-ip}"
    fmg_pass = var.admin_password
  }
}