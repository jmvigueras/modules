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
    vnet-fgt = azurerm_virtual_network.vnet-fgt.name
  }
}

output "fgt-active-ni_ids" {
  value = {
    mgmt    = azurerm_network_interface.ni-active-mgmt.id
    public  = azurerm_network_interface.ni-active-public.id
    private = azurerm_network_interface.ni-active-private.id
    ha      = azurerm_network_interface.ni-active-ha.id
  }
}

output "fgt-active-ni_names" {
  value = {
    mgmt    = azurerm_network_interface.ni-active-mgmt.name
    public  = azurerm_network_interface.ni-active-public.name
    private = azurerm_network_interface.ni-active-private.name
    ha      = azurerm_network_interface.ni-active-ha.name
  }
}

output "fgt-active-ni_ips" {
  value = {
    mgmt    = azurerm_network_interface.ni-active-mgmt.private_ip_address
    public  = azurerm_network_interface.ni-active-public.private_ip_address
    private = azurerm_network_interface.ni-active-private.private_ip_address
    ha      = azurerm_network_interface.ni-active-ha.private_ip_address
  }
}

output "fgt-passive-ni_ids" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.id
    public  = azurerm_network_interface.ni-passive-public.id
    private = azurerm_network_interface.ni-passive-private.id
    ha      = azurerm_network_interface.ni-passive-ha.id
  }
}

output "fgt-passive-ni_names" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.name
    public  = azurerm_network_interface.ni-passive-public.name
    private = azurerm_network_interface.ni-passive-private.name
    ha      = azurerm_network_interface.ni-passive-ha.name
  }
}

output "fgt-passive-ni_ips" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.private_ip_address
    public  = azurerm_network_interface.ni-passive-public.private_ip_address
    private = azurerm_network_interface.ni-passive-private.private_ip_address
    ha      = azurerm_network_interface.ni-passive-ha.private_ip_address
  }
}

output "bastion-ni_id" {
  value = azurerm_network_interface.ni-bastion.id
}

output "fmg_public-ip" {
  value = azurerm_public_ip.fmg_public-ip.ip_address
}

output "faz_public-ip" {
  value = azurerm_public_ip.faz_public-ip.ip_address
}

output "faz_ni_ids" {
  value = {
    public  = azurerm_network_interface.faz_ni_public.id
    private = azurerm_network_interface.faz_ni_private.id
  }
}

output "faz_ni_ips" {
  value = {
    public  = azurerm_network_interface.faz_ni_public.private_ip_address
    private = azurerm_network_interface.faz_ni_private.private_ip_address
  }
}

output "fmg_ni_ids" {
  value = {
    public  = azurerm_network_interface.fmg_ni_public.id
    private = azurerm_network_interface.fmg_ni_private.id
  }
}

output "fmg_ni_ips" {
  value = {
    public  = azurerm_network_interface.fmg_ni_public.private_ip_address
    private = azurerm_network_interface.fmg_ni_private.private_ip_address
  }
}

output "subnet_cidrs" {
  value = {
    mgmt    = azurerm_subnet.subnet-mgmt.address_prefixes[0]
    public  = azurerm_subnet.subnet-public.address_prefixes[0]
    private = azurerm_subnet.subnet-private.address_prefixes[0]
    ha      = azurerm_subnet.subnet-ha.address_prefixes[0]
    vgw     = azurerm_subnet.subnet-vgw.address_prefixes[0]
    rs      = azurerm_subnet.subnet-routeserver.address_prefixes[0]
    bastion = azurerm_subnet.subnet-bastion.address_prefixes[0]
  }
}

output "subnet_names" {
  value = {
    mgmt    = azurerm_subnet.subnet-mgmt.name
    public  = azurerm_subnet.subnet-public.name
    private = azurerm_subnet.subnet-private.name
    ha      = azurerm_subnet.subnet-ha.name
    vgw     = azurerm_subnet.subnet-vgw.name
    rs      = azurerm_subnet.subnet-routeserver.name
    bastion = azurerm_subnet.subnet-bastion.name
  }
}

output "subnet_ids" {
  value = {
    mgmt    = azurerm_subnet.subnet-mgmt.id
    public  = azurerm_subnet.subnet-public.id
    private = azurerm_subnet.subnet-private.id
    ha      = azurerm_subnet.subnet-ha.id
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
    faz-fmg = azurerm_network_security_group.nsg-faz-fmg.id
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