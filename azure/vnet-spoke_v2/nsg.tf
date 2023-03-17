//  Network Security Group

resource "azurerm_network_security_group" "nsg_spoke" {
  name                = "${var.prefix}-nsg-vnet-spoke"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsr_spoke_ingress_allow_all" {
  name                        = "${var.prefix}-nsr-spoke-ingress-allow-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke.name
}

resource "azurerm_network_security_rule" "nsr_spoke_egress_allow_all" {
  name                        = "${var.prefix}-nsr-spoke-egress-allow-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke.name
}

# Connect the security group to Bastion Subnet
resource "azurerm_subnet_network_security_group_association" "ni_subnet_1-nsg-association" {
  subnet_id                 = azurerm_subnet.vnet-spoke_subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg_spoke.id
}