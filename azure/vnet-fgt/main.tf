######################################################################
## Create VNET FGT and subnets
######################################################################

resource "azurerm_virtual_network" "vnet-fgt" {
  name                = "${var.prefix}-vnet-fgt"
  address_space       = [var.vnet-fgt_cidr]
  location            = var.location
  resource_group_name = var.resourcegroup_name

  tags = var.tags
}

resource "azurerm_subnet" "subnet-hamgmt" {
  name                 = "${var.prefix}-subnet-hamgmt"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 1)]
}

resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.prefix}-subnet-public"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 2)]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.prefix}-subnet-private"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 3)]
}

resource "azurerm_subnet" "subnet-bastion" {
  name                 = "${var.prefix}-subnet-bastion"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 4)]
}

resource "azurerm_subnet" "subnet-vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 6)]
}

resource "azurerm_subnet" "subnet-routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 7)]
}

######################################################################
## Create public IPs and interfaces (Active and passive FGT)
######################################################################
// // Public service IPs (public interfaces)
resource "azurerm_public_ip" "cluster-public-ip" {
  name                = "${var.prefix}-cluster-public-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
resource "azurerm_public_ip" "passive-public-ip" {
  name                = "${var.prefix}-passive-public-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
// Public MGMT IPs (mgmt interfaces)
resource "azurerm_public_ip" "active-mgmt-ip" {
  name                = "${var.prefix}-active-mgmt-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
resource "azurerm_public_ip" "passive-mgmt-ip" {
  name                = "${var.prefix}-passive-mgmt-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}

// Active FGT Network Interface port1
resource "azurerm_network_interface" "ni-activeport1" {
  name                          = "${var.prefix}-ni-activeport1"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-hamgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-hamgmt.address_prefixes[0], 10)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.active-mgmt-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-activeport2" {
  name                          = "${var.prefix}-ni-activeport2"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0], 10)
    public_ip_address_id          = azurerm_public_ip.cluster-public-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-activeport3" {
  name                          = "${var.prefix}-ni-activeport3"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-private.address_prefixes[0], 10)
  }

  tags = var.tags
}

// Passive FGT Network Interface port1
resource "azurerm_network_interface" "ni-passiveport1" {
  name                          = "${var.prefix}-ni-passiveport1"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-hamgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-hamgmt.address_prefixes[0], 11)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.passive-mgmt-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-passiveport2" {
  name                          = "${var.prefix}-ni-passiveport2"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0], 11)
    public_ip_address_id          = azurerm_public_ip.passive-public-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-passiveport3" {
  name                          = "${var.prefix}-ni-passiveport3"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-private.address_prefixes[0], 11)
  }

  tags = var.tags
}


// Bastion public IP
resource "azurerm_public_ip" "bastion-public-ip" {
  name                = "${var.prefix}-bastion-public-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}

// Bastion Network Interface
resource "azurerm_network_interface" "ni-bastion" {
  name                = "${var.prefix}-ni-bastion"
  location            = var.location
  resource_group_name = var.resourcegroup_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-bastion.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-bastion.address_prefixes[0], 10)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.bastion-public-ip.id
  }
  tags = var.tags
}