# Output
output "fgt_onramp" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt_onramp.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-2_mgmt   = "https://${module.fgt_onramp.fgt_passive_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt_onramp.fgt_active_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt_onramp.fgt_active_id
    fgt-2_pass   = module.fgt_onramp.fgt_passive_id
    admin_cidr   = "${chomp(data.http.my-public-ip.body)}/32"
    api_key      = module.fgt_onramp_config.api_key
  }
}
output "vm_fgt_vpc-spoke" {
  value = module.vm_fgt_vpc-spoke.*.vm
}
