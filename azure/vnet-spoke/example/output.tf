
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

output "ni_pips" {
  value = module.vnet-spoke.ni_pips
}