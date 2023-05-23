# Output
output "fgt" {
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

output "vm_bastion_az1" {
  value = module.vm_bastion_az1.vm
}

output "vm_bastion_az2" {
  value = module.vm_bastion_az2.vm
}