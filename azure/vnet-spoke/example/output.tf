
output "vnet_ids" {
  value = module.vnet-spoke.vnet_ids
}

output "vnet_names" {
  value = module.vnet-spoke.vnet_names
}

output "vnet_cidrs" {
  value = module.vnet-spoke.vnet_cidrs
}

output "subnet_ids" {
  value = module.vnet-spoke.subnet_ids
}

output "subnet_names" {
  value = module.vnet-spoke.subnet_names
}

output "subnet_cidrs" {
  value = module.vnet-spoke.subnet_cidrs
}

output "nsg_ids" {
  value = module.vnet-spoke.nsg_ids
}

output "ni_ids" {
  value = module.vnet-spoke.ni_ids
}

output "ni_ips" {
  value = module.vnet-spoke.ni_ips
}

output "ni_ids_subnet1" {
  value = { 
    n1 = module.vnet-spoke.ni_ids["subnet1"][0]
    n2 = module.vnet-spoke.ni_ids["subnet1"][1]
    n1-ip = module.vnet-spoke.ni_ips["subnet1"][0]
    n2-ip = module.vnet-spoke.ni_ips["subnet1"][1]
  }
}