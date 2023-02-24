output "fgt-active-mgmt-ip" {
  value = azurerm_public_ip.active-mgmt-ip.ip_address
}

output "fgt-passive-mgmt-ip" {
  value = azurerm_public_ip.passive-mgmt-ip.ip_address
}

output "fgt-active-public-ip" {
  value = azurerm_public_ip.active-public-ip.ip_address
}

output "fgt-active-public-name" {
  value = azurerm_public_ip.active-public-ip.name
}

output "fgt-passive-public-ip" {
  value = azurerm_public_ip.passive-public-ip.ip_address
}

output "fgt-passive-public-name" {
  value = azurerm_public_ip.passive-public-ip.name
}

output "fgt-active-ni_ids" {
  value = {
    mgmt    = azurerm_network_interface.ni-active-mgmt.id
    public  = azurerm_network_interface.ni-active-public.id
    private = azurerm_network_interface.ni-active-private.id
  }
}

output "fgt-active-ni_names" {
  value = {
    mgmt    = azurerm_network_interface.ni-active-mgmt.name
    public  = azurerm_network_interface.ni-active-public.name
    private = azurerm_network_interface.ni-active-private.name
  }
}

output "fgt-active-ni_ips" {
  value = {
    mgmt    = azurerm_network_interface.ni-active-mgmt.private_ip_address
    public  = azurerm_network_interface.ni-active-public.private_ip_address
    private = azurerm_network_interface.ni-active-private.private_ip_address
  }
}

output "fgt-passive-ni_ids" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.id
    public  = azurerm_network_interface.ni-passive-public.id
    private = azurerm_network_interface.ni-passive-private.id
  }
}

output "fgt-passive-ni_names" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.name
    public  = azurerm_network_interface.ni-passive-public.name
    private = azurerm_network_interface.ni-passive-private.name
  }
}

output "fgt-passive-ni_ips" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.private_ip_address
    public  = azurerm_network_interface.ni-passive-public.private_ip_address
    private = azurerm_network_interface.ni-passive-private.private_ip_address
  }
}

output "nsg_ids" {
  value = {
    mgmt    = azurerm_network_security_group.nsg-mgmt-ha.id
    public  = azurerm_network_security_group.nsg-public.id
    private = azurerm_network_security_group.nsg-private.id
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