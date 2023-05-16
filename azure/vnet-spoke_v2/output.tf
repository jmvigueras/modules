
output "vnet_id" {
  value = azurerm_virtual_network.vnet-spoke.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet-spoke.name
}

output "vnet_cidr" {
  value = azurerm_virtual_network.vnet-spoke.address_space[0]
}

output "subnet_ids" {
  value = {
    subnet_1    = azurerm_subnet.vnet-spoke_subnet_1.id
    subnet_2    = azurerm_subnet.vnet-spoke_subnet_2.id
    routeserver = azurerm_subnet.vnet-spoke_subnet_routeserver.id
    vgw         = azurerm_subnet.vnet-spoke_subnet_vgw.id
  }
}

output "subnet_names" {
  value = {
    subnet_1    = azurerm_subnet.vnet-spoke_subnet_1.name
    subnet_2    = azurerm_subnet.vnet-spoke_subnet_2.name
    routeserver = azurerm_subnet.vnet-spoke_subnet_routeserver.name
    vgw         = azurerm_subnet.vnet-spoke_subnet_vgw.name
  }
}

output "subnet_cidrs" {
  value = {
    subnet_1    = azurerm_subnet.vnet-spoke_subnet_1.address_prefixes[0]
    subnet_2    = azurerm_subnet.vnet-spoke_subnet_2.address_prefixes[0]
    routeserver = azurerm_subnet.vnet-spoke_subnet_routeserver.address_prefixes[0]
    vgw         = azurerm_subnet.vnet-spoke_subnet_vgw.address_prefixes[0]
  }
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg_spoke.id
}