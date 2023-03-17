//  Network Security Group

resource "azurerm_network_security_group" "nsg-hub-spoke" {
  name                = "${var.prefix}-nsg-vnet-spoke"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr-hub-ingress-spoke" {
  name                        = "${var.prefix}-nsr-hub-ingress-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-hub-spoke.name
}

resource "azurerm_network_security_rule" "nsr-hub-egress-spoke" {
  name                        = "${var.prefix}-nsr-hub-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-hub-spoke.name
}


# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "ni_subnet_1-nsg-association" {
  network_interface_id      = azurerm_network_interface.ni_subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg-hub-spoke.id
}

resource "azurerm_network_interface_security_group_association" "ni_subnet_2-nsg-association" {
  network_interface_id      = azurerm_network_interface.ni_subnet_2.id
  network_security_group_id = azurerm_network_security_group.nsg-hub-spoke.id
}