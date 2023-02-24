#------------------------------------------------------------------------------
# Create public IPs and interfaces (Active and passive FGT) 3 ports
#------------------------------------------------------------------------------
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
    subnet_id                     = var.subnet_ids["mgmt"]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ni-active-mgmt_ip
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
    subnet_id                     = var.subnet_ids["public"]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ni-active-public_ip
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
    subnet_id                     = var.subnet_ids["private"]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ni-active-private_ip
  }

  tags = var.tags
}

// Passive FGT Network Interface mgmt
resource "azurerm_network_interface" "ni-passive-mgmt" {
  name                          = "${var.prefix}-ni-passive-mgmt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_ids["mgmt"]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ni-passive-mgmt_ip
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
    subnet_id                     = var.subnet_ids["public"]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ni-passive-public_ip
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
    subnet_id                     = var.subnet_ids["private"]
    private_ip_address_allocation = "Static"
    private_ip_address            = local.ni-passive-private_ip
  }

  tags = var.tags
}