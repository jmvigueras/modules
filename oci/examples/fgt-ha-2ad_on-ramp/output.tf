output "fgt_1" {
  value = {
    id         = module.fgt.fgt_1_id
    mgmt_ip    = module.fgt.fgt_1_public_ip_mgmt
    admin_port = local.admin_port
  }
}
output "fgt_2" {
  value = {
    id         = module.fgt.fgt_2_id
    mgmt_ip    = module.fgt.fgt_2_public_ip_mgmt
    admin_port = local.admin_port
  }
}