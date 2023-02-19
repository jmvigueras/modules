######################################################################
## Create VNET FGT and subnets
######################################################################
resource "azurerm_virtual_network" "vnet-fgt" {
  name                = "${var.prefix}-vnet-fgt"
  address_space       = [var.vnet-fgt_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "subnet-ha" {
  name                 = "${var.prefix}-subnet-ha"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 0)]
}

resource "azurerm_subnet" "subnet-mgmt" {
  name                 = "${var.prefix}-subnet-mgmt"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 1)]
}

resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.prefix}-subnet-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 2)]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.prefix}-subnet-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 3)]
}

resource "azurerm_subnet" "subnet-bastion" {
  name                 = "${var.prefix}-subnet-bastion"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 4)]
}

resource "azurerm_subnet" "subnet-vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 6)]
}

resource "azurerm_subnet" "subnet-routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt_cidr, 3, 7)]
}

######################################################################
## Create public IPs and interfaces (Active and passive FGT)
######################################################################
// // Public service IPs (public interfaces)
resource "azurerm_public_ip" "active-public-ip" {
  name                = "${var.prefix}-active-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
resource "azurerm_public_ip" "passive-public-ip" {
  name                = "${var.prefix}-passive-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
// Public MGMT IPs (mgmt interfaces)
resource "azurerm_public_ip" "active-mgmt-ip" {
  name                = "${var.prefix}-active-mgmt-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
resource "azurerm_public_ip" "passive-mgmt-ip" {
  name                = "${var.prefix}-passive-mgmt-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}

// Active FGT Network Interface MGMT
resource "azurerm_network_interface" "ni-active-mgmt" {
  name                          = "${var.prefix}-ni-active-mgmt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-mgmt.address_prefixes[0], 10)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.active-mgmt-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-active-public" {
  name                          = "${var.prefix}-ni-active-public"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0], 10)
    public_ip_address_id          = azurerm_public_ip.active-public-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-active-private" {
  name                          = "${var.prefix}-ni-active-private"
  location                      = var.location
  resource_group_name           = var.resource_group_name
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

resource "azurerm_network_interface" "ni-active-ha" {
  name                          = "${var.prefix}-ni-active-ha"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ha.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-ha.address_prefixes[0], 10)
  }

  tags = var.tags
}

// Passive FGT Network Interface port1
resource "azurerm_network_interface" "ni-passive-mgmt" {
  name                          = "${var.prefix}-ni-passive-mgmt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-mgmt.address_prefixes[0], 11)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.passive-mgmt-ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "ni-passive-public" {
  name                          = "${var.prefix}-ni-passive-public"
  location                      = var.location
  resource_group_name           = var.resource_group_name
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

resource "azurerm_network_interface" "ni-passive-private" {
  name                          = "${var.prefix}-ni-passive-private"
  location                      = var.location
  resource_group_name           = var.resource_group_name
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

resource "azurerm_network_interface" "ni-passive-ha" {
  name                          = "${var.prefix}-ni-passive-ha"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ha.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-ha.address_prefixes[0], 11)
  }

  tags = var.tags
}

// Bastion public IP
resource "azurerm_public_ip" "bastion-public-ip" {
  name                = "${var.prefix}-bastion-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}

// Bastion Network Interface
resource "azurerm_network_interface" "ni-bastion" {
  name                = "${var.prefix}-ni-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

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

#------------------------------------------------------------------------------
# Create FAZ and FMG interfaces
#------------------------------------------------------------------------------
// FAZ public IP
resource "azurerm_public_ip" "faz_public-ip" {
  name                = "${var.prefix}-faz-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
// FAZ Network Interface (public subnet)
resource "azurerm_network_interface" "faz_ni_public" {
  name                = "${var.prefix}-faz-ni-public"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0], 12)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.faz_public-ip.id
  }
  tags = var.tags
}
// FAZ Network Interface (private subnet)
resource "azurerm_network_interface" "faz_ni_private" {
  name                = "${var.prefix}-faz-ni-private"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-bastion.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-bastion.address_prefixes[0], 12)
  }
  tags = var.tags
}

// FMG public IP
resource "azurerm_public_ip" "fmg_public-ip" {
  name                = "${var.prefix}-fmg-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
// FMG Network Interface (public subnet)
resource "azurerm_network_interface" "fmg_ni_public" {
  name                = "${var.prefix}-fmg-ni-public"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0], 13)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.fmg_public-ip.id
  }
  tags = var.tags
}
// FMG Network Interface (private subnet)
resource "azurerm_network_interface" "fmg_ni_private" {
  name                = "${var.prefix}-fmg-ni-private"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-bastion.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-bastion.address_prefixes[0], 13)
  }
  tags = var.tags
}
