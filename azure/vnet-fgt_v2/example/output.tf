output "fgt-active-mgmt-ip" {
  value = module.vnet-fgt.fgt-active-mgmt-ip
}

output "fgt-passive-mgmt-ip" {
  value = module.vnet-fgt.fgt-passive-mgmt-ip
}

output "active-public-ip_ip" {
  value = module.vnet-fgt.fgt-active-public-ip
}

output "vnet" {
  value = module.vnet-fgt.vnet
}

output "fgt-active-ni_ids" {
  value = module.vnet-fgt.fgt-active-ni_ids
}

output "fgt-active-ni_names" {
  value = module.vnet-fgt.fgt-active-ni_names
}

output "fgt-active-ni_ips" {
  value = module.vnet-fgt.fgt-active-ni_ips
}

output "fgt-passive-ni_ids" {
  value = module.vnet-fgt.fgt-passive-ni_ids
}

output "fgt-passive-ni_names" {
  value = module.vnet-fgt.fgt-passive-ni_names
}

output "fgt-passive-ni_ips" {
  value = module.vnet-fgt.fgt-passive-ni_ips
}

output "subnet_cidrs" {
  value = module.vnet-fgt.subnet_cidrs
}

output "subnet_names" {
  value = module.vnet-fgt.subnet_names
}

output "subnet_ids" {
  value = module.vnet-fgt.subnet_ids
}

output "nsg-public_id" {
  value = module.vnet-fgt.nsg-public_id
}

output "nsg-private_id" {
  value = module.vnet-fgt.nsg-private_id
}

output "nsg-mgmt-ha_id" {
  value = module.vnet-fgt.nsg-mgmt-ha_id
}

output "nsg_ids" {
  value = module.vnet-fgt.nsg_ids
}