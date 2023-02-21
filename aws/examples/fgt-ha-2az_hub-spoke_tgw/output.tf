# Output
output "fgt_hub1" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt_hub1_vpc.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-2_mgmt   = "https://${module.fgt_hub1_vpc.fgt_passive_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt_hub1_vpc.fgt_active_eip_public
    fgt-2_public = module.fgt_hub1_vpc.fgt_passive_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt_hub1.fgt_active_id
    fgt-2_pass   = module.fgt_hub1.fgt_passive_id
    vpn_psk      = module.fgt_hub1_config.vpn_psk
    admin_cidr   = "${chomp(data.http.my-public-ip.body)}/32"
    api_key      = module.fgt_hub1_config.api_key
  }
}
output "fgt_hub2" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt_hub2_vpc.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-2_mgmt   = "https://${module.fgt_hub2_vpc.fgt_passive_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt_hub2_vpc.fgt_active_eip_public
    fgt-2_public = module.fgt_hub2_vpc.fgt_passive_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt_hub2.fgt_active_id
    fgt-2_pass   = module.fgt_hub2.fgt_passive_id
    vpn_psk      = module.fgt_hub2_config.vpn_psk
    admin_cidr   = "${chomp(data.http.my-public-ip.body)}/32"
    api_key      = module.fgt_hub2_config.api_key
  }
}
output "fgt_spoke" {
  value = {
    username   = "admin"
    fgt-1_mgmt = module.fgt_spoke_vpc.*.fgt_active_eip_mgmt
    fgt-1_pass = module.fgt_spoke.*.fgt_active_id
    admin_cidr = "${chomp(data.http.my-public-ip.body)}/32"
    api_key    = module.fgt_spoke_config.*.api_key
  }
}
output "vm_fgt_hub1" {
  value = module.vm_fgt_hub1.vm
}
output "vm_tgw_hub1" {
  value = module.vm_tgw_hub1.*.vm
}
output "vm_fgt_hub2" {
  value = module.vm_fgt_hub2.vm
}
output "vm_fgt_spoke" {
  value = module.vm_fgt_spoke.*.vm
}