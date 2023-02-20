#----------------------------------------------------------------------------------
# Create vNet and Subnets
#----------------------------------------------------------------------------------
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
  address_prefixes     = [local.subnet_ha_cidr]
}

resource "azurerm_subnet" "subnet-mgmt" {
  name                 = "${var.prefix}-subnet-mgmt"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_mgmt_cidr]
}

resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.prefix}-subnet-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_public_cidr]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.prefix}-subnet-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_private_cidr]
}

resource "azurerm_subnet" "subnet-bastion" {
  name                 = "${var.prefix}-subnet-bastion"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_bastion_cidr]
}

resource "azurerm_subnet" "subnet-vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_vgw_cidr]
}

resource "azurerm_subnet" "subnet-routeserver" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_routeserver_cidr]
}

#----------------------------------------------------------------------------------
# Create public IPs
#----------------------------------------------------------------------------------
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

#----------------------------------------------------------------------------------
# Create Network Interfaces
# - FGT-1 network interfaces
# - FGT-2 network interfaces
#----------------------------------------------------------------------------------
// Active FGT Network Interface
resource "azurerm_network_interface" "ni-active-ha" {
  name                          = "${var.prefix}-ni-active-ha"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ha.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.fgt-1_ni_ha_ip
  }

  tags = var.tags
}
resource "azurerm_network_interface" "ni-active-mgmt" {
  name                          = "${var.prefix}-ni-active-mgmt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.fgt-1_ni_mgmt_ip
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
    private_ip_address            = local.fgt-1_ni_public_ip
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
    private_ip_address            = local.fgt-1_ni_private_ip
  }

  tags = var.tags
}

// Passive FGT Network Interface port1
resource "azurerm_network_interface" "ni-passive-ha" {
  name                          = "${var.prefix}-ni-passive-ha"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ha.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.fgt-2_ni_ha_ip
  }

  tags = var.tags
}
resource "azurerm_network_interface" "ni-passive-mgmt" {
  name                          = "${var.prefix}-ni-passive-mgmt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.fgt-2_ni_mgmt_ip
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
    private_ip_address            = local.fgt-2_ni_public_ip
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
    private_ip_address            = local.fgt-2_ni_private_ip
  }

  tags = var.tags
}

#----------------------------------------------------------------------------------
# Create Bastion Public IP and Network Interface
#----------------------------------------------------------------------------------
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
    private_ip_address            = local.bastion_ni_ip
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
    private_ip_address            = local.faz_ni_public_ip
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
    private_ip_address            = local.faz_ni_private_ip
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
    private_ip_address            = local.fmg_ni_public_ip
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
    private_ip_address            = local.fmg_ni_private_ip
  }
  tags = var.tags
}
