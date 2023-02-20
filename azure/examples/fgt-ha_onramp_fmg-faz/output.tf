output "fgt" {
  value = {
    admin        = local.admin_username
    pass         = local.admin_password
    api_key      = module.fgt_config.api_key
    active_mgmt  = "https://${module.fgt_vnet.fgt-active-mgmt-ip}:${local.admin_port}"
    passive_mgmt = "https://${module.fgt_vnet.fgt-passive-mgmt-ip}:${local.admin_port}"
    vpn_psk      = module.fgt_config.vpn_psk
  }
}

output "faz" {
  value = {
    faz_mgmt = "https://${module.fgt_vnet.faz_public-ip}"
    faz_pass = local.admin_password
  }
}

output "fmg" {
  value = {
    fmg_mgmt = "https://${module.fgt_vnet.fmg_public-ip}"
    fmg_pass = local.admin_password
  }
}