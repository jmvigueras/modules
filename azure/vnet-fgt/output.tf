output "fgt-active-mgmt-ip" {
  value = azurerm_public_ip.active-mgmt-ip.ip_address
}

output "fgt-passive-mgmt-ip" {
  value = azurerm_public_ip.passive-mgmt-ip.ip_address
}

output "cluster-public-ip_ip" {
  value = azurerm_public_ip.cluster-public-ip.ip_address
}

output "cluster-public-ip_name" {
  value = azurerm_public_ip.cluster-public-ip.name
}

output "bastion-public-ip_ip" {
  value = azurerm_public_ip.bastion-public-ip.ip_address
}

output "vnet" {
  value = {
    name = azurerm_virtual_network.vnet-fgt.name
    id   = azurerm_virtual_network.vnet-fgt.id
  }
}

output "vnet_names" {
  value = {
    "vnet-fgt" = azurerm_virtual_network.vnet-fgt.name
  }
}

output "fgt-active-ni_ids" {
  value = {
    port1 = azurerm_network_interface.ni-activeport1.id
    port2 = azurerm_network_interface.ni-activeport2.id
    port3 = azurerm_network_interface.ni-activeport3.id
  }
}

output "fgt-active-ni_names" {
  value = {
    port1 = azurerm_network_interface.ni-activeport1.name
    port2 = azurerm_network_interface.ni-activeport2.name
    port3 = azurerm_network_interface.ni-activeport3.name
  }
}

output "fgt-active-ni_ips" {
  value = {
    port1 = azurerm_network_interface.ni-activeport1.private_ip_address
    port2 = azurerm_network_interface.ni-activeport2.private_ip_address
    port3 = azurerm_network_interface.ni-activeport3.private_ip_address
  }
}

output "fgt-passive-ni_ids" {
  value = {
    port1 = azurerm_network_interface.ni-passiveport1.id
    port2 = azurerm_network_interface.ni-passiveport2.id
    port3 = azurerm_network_interface.ni-passiveport3.id
  }
}

output "bastion-ni_id" {
  value = azurerm_network_interface.ni-bastion.id
}

output "fgt-passive-ni_names" {
  value = {
    port1 = azurerm_network_interface.ni-passiveport1.name
    port2 = azurerm_network_interface.ni-passiveport2.name
    port3 = azurerm_network_interface.ni-passiveport3.name
  }
}

output "fgt-passive-ni_ips" {
  value = {
    port1 = azurerm_network_interface.ni-passiveport1.private_ip_address
    port2 = azurerm_network_interface.ni-passiveport2.private_ip_address
    port3 = azurerm_network_interface.ni-passiveport3.private_ip_address
  }
}

output "subnet_cidrs" {
  value = {
    mgmt    = azurerm_subnet.subnet-hamgmt.address_prefixes[0]
    public  = azurerm_subnet.subnet-public.address_prefixes[0]
    private = azurerm_subnet.subnet-private.address_prefixes[0]
    vgw     = azurerm_subnet.subnet-vgw.address_prefixes[0]
    rs      = azurerm_subnet.subnet-routeserver.address_prefixes[0]
    bastion = azurerm_subnet.subnet-bastion.address_prefixes[0]
  }
}

output "subnet_names" {
  value = {
    mgmt    = azurerm_subnet.subnet-hamgmt.name
    public  = azurerm_subnet.subnet-public.name
    private = azurerm_subnet.subnet-private.name
    vgw     = azurerm_subnet.subnet-vgw.name
    rs      = azurerm_subnet.subnet-routeserver.name
    bastion = azurerm_subnet.subnet-bastion.name
  }
}

output "subnet_ids" {
  value = {
    mgmt    = azurerm_subnet.subnet-hamgmt.id
    public  = azurerm_subnet.subnet-public.id
    private = azurerm_subnet.subnet-private.id
    vgw     = azurerm_subnet.subnet-vgw.id
    rs      = azurerm_subnet.subnet-routeserver.id
    bastion = azurerm_subnet.subnet-bastion.id
  }
}

output "nsg_ids" {
  value = {
    mgmt    = azurerm_network_security_group.nsg-mgmt-ha.id
    public  = azurerm_network_security_group.nsg-public.id
    private = azurerm_network_security_group.nsg-private.id
    bastion = azurerm_network_security_group.nsg-bastion.id
  }
}

output "nsg-public_id" {
  value = azurerm_network_security_group.nsg-public.id
}

output "nsg-private_id" {
  value = azurerm_network_security_group.nsg-private.id
}

output "nsg-mgmt-ha_id" {
  value = azurerm_network_security_group.nsg-mgmt-ha.id
}