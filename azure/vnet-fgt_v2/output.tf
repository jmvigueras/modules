
output "fgt-active-mgmt-ip" {
  value = azurerm_public_ip.active-mgmt-ip.ip_address
}

output "fgt-passive-mgmt-ip" {
  value = azurerm_public_ip.passive-mgmt-ip.ip_address
}

output "fgt-active-public-ip" {
  value = var.config_xlb ? "ExternalLB_FrontEnd" : azurerm_public_ip.active-public-ip[0].ip_address
}

output "fgt-active-public-name" {
  value = local.fgt-1_public_ip_name
}
output "fgt-passive-public-name" {
  value = local.fgt-2_public_ip_name
}

output "fgt-passive-public-ip" {
  value = var.config_xlb ? "ExternalLB_FrontEnd" : azurerm_public_ip.passive-public-ip[0].ip_address
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
    public  = local.fgt-1_ni_public_id
    private = azurerm_network_interface.ni-active-private.id
  }
}

output "fgt-active-ni_names" {
  value = {
    mgmt    = local.fgt-1_ni_mgmt_name
    public  = local.fgt-1_ni_public_name
    private = local.fgt-1_ni_private_name
  }
}

output "fgt-active-ni_ips" {
  value = {
    mgmt    = local.fgt-1_ni_mgmt_ip
    public  = local.fgt-1_ni_public_ip
    private = local.fgt-1_ni_private_ip
  }
}

output "fgt-passive-ni_ids" {
  value = {
    mgmt    = azurerm_network_interface.ni-passive-mgmt.id
    public  = local.fgt-2_ni_public_id
    private = azurerm_network_interface.ni-passive-private.id
  }
}

output "fgt-passive-ni_names" {
  value = {
    mgmt    = local.fgt-2_ni_mgmt_name
    public  = local.fgt-2_ni_public_name
    private = local.fgt-2_ni_private_name
  }
}

output "fgt-passive-ni_ips" {
  value = {
    mgmt    = local.fgt-2_ni_mgmt_ip
    public  = local.fgt-2_ni_public_ip
    private = local.fgt-2_ni_private_ip
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
    mgmt            = azurerm_network_security_group.nsg-mgmt-ha.id
    public          = azurerm_network_security_group.nsg-public.id
    private         = azurerm_network_security_group.nsg-private.id
    bastion         = azurerm_network_security_group.nsg_bastion_admin_cidr.id
    bastion_default = azurerm_network_security_group.nsg_bastion_default.id
    public_default  = azurerm_network_security_group.nsg-public-default.id
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