# Output
output "fgt_onramp" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-2_mgmt   = "https://${module.fgt.fgt_passive_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt.fgt_active_eip_public
    fgt-2_public = module.fgt.fgt_passive_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt.fgt_active_id
    fgt-2_pass   = module.fgt.fgt_passive_id
    admin_cidr   = "${chomp(data.http.my-public-ip.response_body)}/32"
    api_key      = module.fgt_config.api_key
  }
}

output "fgt_hub" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt_hub.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt_hub.fgt_active_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt_hub.fgt_active_id
    admin_cidr   = "${chomp(data.http.my-public-ip.response_body)}/32"
    api_key      = module.fgt_hub_config.api_key
  }
}

output "vm_spoke" {
  value = module.vm_spoke.*.vm
}

output "vm_hub" {
  value = module.vm_hub.vm
}