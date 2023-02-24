output "fgt" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-1_pass   = module.fgt.fgt_active_id
    fgt-2_mgmt   = module.fgt.fgt_passive_eip_mgmt
    fgt-2_pass   = module.fgt.fgt_passive_id
    fgt-1_public = module.fgt.fgt_active_eip_public
    api_key      = module.fgt_config.api_key
    vpn_psk      = module.fgt_config.vpn_psk
  }
}

output "faz" {
  value = {
    mgmt_url   = "https://${module.faz.faz_public-ip}"
    admin_user = "admin"
    admin_pass = module.faz.faz_id
  }
}

output "fmg" {
  value = {
    mgmt_url   = "https://${module.fmg.fmg_public-ip}"
    admin_user = "admin"
    admin_pass = module.fmg.fmg_id
  }
}