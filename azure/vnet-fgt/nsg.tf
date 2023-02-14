//  Network Security Group
resource "azurerm_network_security_group" "nsg-mgmt-ha" {
  name                = "${var.prefix}-nsg-mgmt-ha"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr-ingress-mgmt-ha-sync" {
  name                        = "${var.prefix}-nsr-ingress-sync"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.subnet-hamgmt.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.subnet-hamgmt.address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}

resource "azurerm_network_security_rule" "nsr-ingress-mgmt-ha-ssh" {
  name                        = "${var.prefix}-nsr-ingress-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.admin_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}

resource "azurerm_network_security_rule" "nsr-ingress-mgmt-ha-https" {
  name                        = "${var.prefix}-nsr-ingress-https"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.admin_port
  source_address_prefix       = var.admin_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}

resource "azurerm_network_security_rule" "nsr-egress-mgmt-ha-all" {
  name                        = "${var.prefix}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}


resource "azurerm_network_security_group" "nsg-public" {
  name                = "${var.prefix}-nsg-public"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr-ingress-public-tcp" {
  name                        = "${var.prefix}-nsr-ingress-vxlan-4789"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "4789"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-ingress-public-ipsec-500" {
  name                        = "${var.prefix}-nsr-ingress-ipsec-500"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "500"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-ingress-public-ipsec-4500" {
  name                        = "${var.prefix}-nsr-ingress-ipsec-4500"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "4500"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-egress-public-all" {
  name                        = "${var.prefix}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_group" "nsg-private" {
  name                = "${var.prefix}-nsg-private"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr-ingress-private-all" {
  name                        = "${var.prefix}-nsr-ingress-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-private.name
}

resource "azurerm_network_security_rule" "nsr-egress-private-all" {
  name                        = "${var.prefix}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-private.name
}

################################################################################
# Associate NSG to interfaces

# Connect the security group to the network interfaces FGT active
resource "azurerm_network_interface_security_group_association" "ni-active-mgmt-nsg" {
  network_interface_id      = azurerm_network_interface.ni-active-mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt-ha.id
}

resource "azurerm_network_interface_security_group_association" "ni-active-public-nsg" {
  network_interface_id      = azurerm_network_interface.ni-active-public.id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

resource "azurerm_network_interface_security_group_association" "ni-active-private-nsg" {
  network_interface_id      = azurerm_network_interface.ni-active-private.id
  network_security_group_id = azurerm_network_security_group.nsg-private.id
}

# Connect the security group to the network interfaces FGT passive
resource "azurerm_network_interface_security_group_association" "ni-passive-mgmt-nsg" {
  network_interface_id      = azurerm_network_interface.ni-passive-mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt-ha.id
}

resource "azurerm_network_interface_security_group_association" "ni-passive-public-nsg" {
  network_interface_id      = azurerm_network_interface.ni-passive-public.id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

resource "azurerm_network_interface_security_group_association" "ni-passive-private-nsg" {
  network_interface_id      = azurerm_network_interface.ni-passive-private.id
  network_security_group_id = azurerm_network_security_group.nsg-private.id
}

#-----------------------------------------------------------------------------------
# Bastion NSG

resource "azurerm_network_security_group" "nsg-bastion" {
  name                = "${var.prefix}-nsg-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr-ingress-bastion-all" {
  name                        = "${var.prefix}-nsr-ingress-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.admin_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-bastion.name
}

resource "azurerm_network_security_rule" "nsr-egress-bastion-all" {
  name                        = "${var.prefix}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-bastion.name
}

resource "azurerm_network_interface_security_group_association" "bastionnsg" {
  network_interface_id      = azurerm_network_interface.ni-bastion.id
  network_security_group_id = azurerm_network_security_group.nsg-bastion.id
}

#-----------------------------------------------------------------------------------
# FAZ-FMG NSG

resource "azurerm_network_security_group" "nsg-faz-fmg" {
  name                = "${var.prefix}-nsg-faz-fmg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr-ingress-faz-fmg-all" {
  name                        = "${var.prefix}-nsr-ingress-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-faz-fmg.name
}

resource "azurerm_network_security_rule" "nsr-egress-faz-fmg-all" {
  name                        = "${var.prefix}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-faz-fmg.name
}

resource "azurerm_network_interface_security_group_association" "faz_ni_public-nsg" {
  network_interface_id      = azurerm_network_interface.faz_ni_public.id
  network_security_group_id = azurerm_network_security_group.nsg-faz-fmg.id
}

resource "azurerm_network_interface_security_group_association" "faz_ni_private-nsg" {
  network_interface_id      = azurerm_network_interface.faz_ni_private.id
  network_security_group_id = azurerm_network_security_group.nsg-faz-fmg.id
}

resource "azurerm_network_interface_security_group_association" "fmg_ni_public-nsg" {
  network_interface_id      = azurerm_network_interface.fmg_ni_public.id
  network_security_group_id = azurerm_network_security_group.nsg-faz-fmg.id
}

resource "azurerm_network_interface_security_group_association" "fmg_ni_private-nsg" {
  network_interface_id      = azurerm_network_interface.fmg_ni_private.id
  network_security_group_id = azurerm_network_security_group.nsg-faz-fmg.id
}