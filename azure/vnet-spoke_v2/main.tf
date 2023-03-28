################################################################################
# Create VNETs
# (Module will create as much VNET as CIRDS ranges configured in var.vnet_spoke_cidr)
################################################################################
// Create VNETs 
resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "${var.prefix}-vnet-spoke"
  address_space       = [var.vnet_spoke_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

// Create standar subnets in each VNET
resource "azurerm_subnet" "vnet-spoke_subnet_1" {
  name                 = "subnet-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.vnet_spoke_cidr, 2, 0)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_2" {
  name                 = "subnet-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.vnet_spoke_cidr, 2, 1)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.vnet_spoke_cidr, 2, 2)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [cidrsubnet(var.vnet_spoke_cidr, 2, 3)]
}
