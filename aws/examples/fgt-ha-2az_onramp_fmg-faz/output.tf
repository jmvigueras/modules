# Output
output "fgt_onramp" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt_onramp.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-2_mgmt   = "https://${module.fgt_onramp.fgt_passive_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt_onramp.fgt_active_eip_public
    fgt-2_public = module.fgt_onramp.fgt_passive_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt_onramp.fgt_active_id
    fgt-2_pass   = module.fgt_onramp.fgt_passive_id
    admin_cidr   = "${chomp(data.http.my-public-ip.response_body)}/32"
    api_key      = module.fgt_onramp_config.api_key
  }
}

output "faz" {
  value = {
    faz_mgmt = "https://${module.faz.eip_public}"
    faz_pass = module.faz.id
  }
}

output "fmg" {
  value = {
    fmg_mgmt = "https://${module.fmg.eip_public}"
    fmg_pass = module.fmg.id
  }
}