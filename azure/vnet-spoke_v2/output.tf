
output "vnet_ids" {
  value = azurerm_virtual_network.vnet-spoke.id
}

output "vnet_names" {
  value = azurerm_virtual_network.vnet-spoke.name
}

output "vnet_cidrs" {
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

output "nsg_ids" {
  value = azurerm_network_security_group.nsg-hub-spoke.id
}

output "ni_ids" {
  value = {
    subnet1 = azurerm_network_interface.ni_subnet_1.id
    subnet2 = azurerm_network_interface.ni_subnet_2.id
  }
}

output "ni_pips" {
  value = {
    subnet1 = azurerm_public_ip.ni_subnet_1_pip.ip_address
    subnet2 = azurerm_public_ip.ni_subnet_1_pip.ip_address
  }
}

output "ni_ids_subnet_1" {
  value = azurerm_network_interface.ni_subnet_1.id
}
output "ni_ids_subnet_2" {
  value = azurerm_network_interface.ni_subnet_2.id
}

output "ni_pips_subnet_1" {
  value = azurerm_public_ip.ni_subnet_1_pip.ip_address
}
output "ni_pips_subnet_2" {
  value = azurerm_public_ip.ni_subnet_2_pip.ip_address
}

output "ni_ips" {
  value = {
    subnet1 = azurerm_network_interface.ni_subnet_1.private_ip_addresses
    subnet2 = azurerm_network_interface.ni_subnet_2.private_ip_addresses
  }
}