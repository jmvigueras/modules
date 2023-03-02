################################################################################
# Create VNETs
# (Module will create as much VNET as CIRDS ranges configured in var.vnet-spoke_cidrs)
################################################################################
// Create VNETs 
resource "azurerm_virtual_network" "vnet-spoke" {
  count               = length(var.vnet-spoke_cidrs)
  name                = "${var.prefix}-vnet-spoke-${count.index + 1}"
  address_space       = [var.vnet-spoke_cidrs[count.index]]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

// Create standar subnets in each VNET
resource "azurerm_subnet" "vnet-spoke_subnet_1" {
  count                = length(var.vnet-spoke_cidrs)
  name                 = "subnet-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[count.index].name
  address_prefixes     = [cidrsubnet(var.vnet-spoke_cidrs[count.index], 3, 0)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_2" {
  count                = length(var.vnet-spoke_cidrs)
  name                 = "subnet-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[count.index].name
  address_prefixes     = [cidrsubnet(var.vnet-spoke_cidrs[count.index], 3, 1)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_routeserver" {
  count                = length(var.vnet-spoke_cidrs)
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[count.index].name
  address_prefixes     = [cidrsubnet(var.vnet-spoke_cidrs[count.index], 3, 4)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_vgw" {
  count                = length(var.vnet-spoke_cidrs)
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[count.index].name
  address_prefixes     = [cidrsubnet(var.vnet-spoke_cidrs[count.index], 3, 5)]
}

resource "azurerm_subnet" "vnet-spoke_subnet_pl" {
  count                = length(var.vnet-spoke_cidrs)
  name                 = "PrivateLinkSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[count.index].name
  address_prefixes     = [cidrsubnet(var.vnet-spoke_cidrs[count.index], 3, 6)]

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "vnet-spoke_subnet_pl-s" {
  count                = length(var.vnet-spoke_cidrs)
  name                 = "PrivateLinkServicesSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke[count.index].name
  address_prefixes     = [cidrsubnet(var.vnet-spoke_cidrs[count.index], 3, 7)]

  private_link_service_network_policies_enabled = true
}


######################################################################
## Create Network Interfaces in subnet 1 y 2 for test VM
######################################################################
// Create public IP address for NI subnet_1
resource "azurerm_public_ip" "ni_subnet_1_pip" {
  count               = length(var.vnet-spoke_cidrs)
  name                = "${var.prefix}-subnet-1-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}

// Network Interface VM Test Spoke-1 subnet 1
resource "azurerm_network_interface" "ni_subnet_1" {
  count               = length(var.vnet-spoke_cidrs)
  name                = "${var.prefix}-ni-vnet-${count.index + 1}-subnet-1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vnet-spoke_subnet_1[count.index].id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.vnet-spoke_subnet_1[count.index].address_prefixes[0], 10)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.ni_subnet_1_pip[count.index].id
  }

  tags = var.tags
}

// Create public IP address for NI subnet_2
resource "azurerm_public_ip" "ni_subnet_2_pip" {
  count               = length(var.vnet-spoke_cidrs)
  name                = "${var.prefix}-subnet-2-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}

// Network Interface VM Test Spoke-1 subnet 2
resource "azurerm_network_interface" "ni_subnet_2" {
  count               = length(var.vnet-spoke_cidrs)
  name                = "${var.prefix}-ni-vnet-${count.index + 1}-subnet-2"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vnet-spoke_subnet_2[count.index].id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.vnet-spoke_subnet_2[count.index].address_prefixes[0], 10)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.ni_subnet_2_pip[count.index].id
  }

  tags = var.tags
}