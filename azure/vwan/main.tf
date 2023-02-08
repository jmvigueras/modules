//Create Azure vWAN
resource "azurerm_virtual_wan" "vwan" {
  name                = "${var.prefix}-vwan"
  resource_group_name = var.resourcegroup_name
  location            = var.location

  tags = var.tags
}

//Create Azure vHUB
resource "azurerm_virtual_hub" "vhub" {
  name                = "${var.prefix}-vhub"
  resource_group_name = var.resourcegroup_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  sku                 = "Standard"
  address_prefix      = var.vhub_cidr

  tags = var.tags
}

/*
// Create public IP for RouterServer vHUB in VNET FGT
resource "azurerm_public_ip" "public-ip-vhub-rs" {
  count               = var.subnet-fgt_ids == null ? 0 : 1
  name                = "${var.prefix}-vhub-rs-pip"
  resource_group_name = var.resourcegroup_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

// Create Route Server in VNET FGT
resource "azurerm_virtual_hub_ip" "vhub_ip_vnet-fgt" {
  count                        = var.subnet-fgt_ids == null ? 0 : 1
  name                         = "${var.prefix}-vhub_ip_vnet-fgt_routeserver"
  virtual_hub_id               = azurerm_virtual_hub.vhub.id
  public_ip_address_id         = azurerm_public_ip.public-ip-vhub-rs[0].id
  subnet_id                    = var.subnet-fgt_ids["rs"]
}
*/

//Create connection to provided VNET FGT
resource "azurerm_virtual_hub_connection" "vhub_connnection_vnet-fgt" {
  name                      = "${var.prefix}-cx-vnet-fgt"
  virtual_hub_id            = azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = var.vnet-fgt_id
}


//Create BGP connection to FGT VNET
resource "azurerm_virtual_hub_bgp_connection" "vhub_bgp_fgt-1" {
  depends_on                    = [azurerm_virtual_hub_connection.vhub_connnection_vnet-fgt]
  name                          = "${var.prefix}-vhub-bgp-cx-fgt-active"
  virtual_hub_id                = azurerm_virtual_hub.vhub.id
  peer_asn                      = var.fgt-cluster_bgp-asn
  peer_ip                       = var.fgt-cluster_active-ip
  virtual_network_connection_id = azurerm_virtual_hub_connection.vhub_connnection_vnet-fgt.id
}

resource "azurerm_virtual_hub_bgp_connection" "vhub_bgp_fgt-2" {
  depends_on                    = [azurerm_virtual_hub_connection.vhub_connnection_vnet-fgt]
  name                          = "${var.prefix}-vhub-bgp-cx-fgt-passive"
  virtual_hub_id                = azurerm_virtual_hub.vhub.id
  peer_asn                      = var.fgt-cluster_bgp-asn
  peer_ip                       = var.fgt-cluster_passive-ip
  virtual_network_connection_id = azurerm_virtual_hub_connection.vhub_connnection_vnet-fgt.id
}

//Create connection to provided VNETs
resource "azurerm_virtual_hub_connection" "vhub_connnection_vnet" {
  count                     = var.vnet_connection == null ? 0 : length(var.vnet_connection)
  name                      = "${var.prefix}-cx-vnet-${count.index + 1}"
  virtual_hub_id            = azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = var.vnet_connection[count.index]
}