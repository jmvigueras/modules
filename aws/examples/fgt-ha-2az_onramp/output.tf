# Output
output "fgt" {
  value = {
    fgt-1_mgmt   = "https://${module.fgt_vpc.fgt_active_eip_mgmt}:${local.admin_port}"
    fgt-2_mgmt   = "https://${module.fgt_vpc.fgt_passive_eip_mgmt}:${local.admin_port}"
    fgt-1_public = module.fgt_vpc.fgt_active_eip_public
    username     = "admin"
    fgt-1_pass   = module.fgt.fgt_active_id
    fgt-2_pass   = module.fgt.fgt_passive_id
    admin_cidr   = "${chomp(data.http.my-public-ip.body)}/32"
    api_key      = module.fgt_config.api_key
  }
}