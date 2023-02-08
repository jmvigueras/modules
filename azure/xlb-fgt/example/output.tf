output "ilb_private-ip" {
  value = module.xlb-fgt.ilb_private-ip
}

output "elb_public-ip" {
  value = module.xlb-fgt.elb_public-ip
}

output "gwlb_frontip_config_id" {
  value = module.xlb-fgt.gwlb_frontip_config_id
}

