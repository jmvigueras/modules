
output "vnet_ids" {
  value = azurerm_virtual_network.vnet-spoke.*.id
}

output "vnet_names" {
  value = azurerm_virtual_network.vnet-spoke.*.name
}

output "vnet_cidrs" {
  value = azurerm_virtual_network.vnet-spoke.*.address_space[0]
}

output "subnet_ids" {
  value = {
    subnet_1    = azurerm_subnet.vnet-spoke_subnet_1.*.id
    subnet_2    = azurerm_subnet.vnet-spoke_subnet_2.*.id
    routeserver = azurerm_subnet.vnet-spoke_subnet_routeserver.*.id
    vgw         = azurerm_subnet.vnet-spoke_subnet_vgw.*.id
    pl          = azurerm_subnet.vnet-spoke_subnet_pl.*.id
    pl-s        = azurerm_subnet.vnet-spoke_subnet_pl-s.*.id
  }
}

output "subnet_names" {
  value = {
    subnet_1    = azurerm_subnet.vnet-spoke_subnet_1.*.name
    subnet_2    = azurerm_subnet.vnet-spoke_subnet_2.*.name
    routeserver = azurerm_subnet.vnet-spoke_subnet_routeserver.*.name
    vgw         = azurerm_subnet.vnet-spoke_subnet_vgw.*.name
    pl          = azurerm_subnet.vnet-spoke_subnet_pl.*.name
    pl-s        = azurerm_subnet.vnet-spoke_subnet_pl-s.*.name
  }
}

output "subnet_cidrs" {
  value = {
    subnet_1    = azurerm_subnet.vnet-spoke_subnet_1.*.address_prefixes[0]
    subnet_2    = azurerm_subnet.vnet-spoke_subnet_2.*.address_prefixes[0]
    routeserver = azurerm_subnet.vnet-spoke_subnet_routeserver.*.address_prefixes[0]
    vgw         = azurerm_subnet.vnet-spoke_subnet_vgw.*.address_prefixes[0]
    pl          = azurerm_subnet.vnet-spoke_subnet_pl.*.address_prefixes[0]
    pl-s        = azurerm_subnet.vnet-spoke_subnet_pl-s.*.address_prefixes[0]
  }
}

output "nsg_ids" {
  value = azurerm_network_security_group.nsg-hub-spoke.id
}

output "ni_ids" {
  value = {
    subnet1 = azurerm_network_interface.ni_subnet_1.*.id
    subnet2 = azurerm_network_interface.ni_subnet_2.*.id
  }
}

output "ni_ips" {
  value = {
    subnet1 = azurerm_network_interface.ni_subnet_1.*.private_ip_addresses
    subnet2 = azurerm_network_interface.ni_subnet_2.*.private_ip_addresses
  }
}