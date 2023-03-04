// Create public IP for RS
resource "azurerm_public_ip" "public-ip-rs" {
  count               = length(var.subnet_ids)
  name                = "${var.prefix}-rs-${count.index + 1}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

// Create RS resource
resource "azurerm_route_server" "rs" {
  count                = length(var.subnet_ids)
  name                 = "${var.prefix}-rs-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  sku                  = "Standard"
  public_ip_address_id = azurerm_public_ip.public-ip-rs[count.index].id
  subnet_id            = var.subnet_ids[count.index]
}

// Create BGP connections
resource "azurerm_route_server_bgp_connection" "rs-spoke-bgp-fgt-active" {
  count           = length(var.subnet_ids)
  name            = "${var.prefix}-bgp-fgt-active"
  route_server_id = azurerm_route_server.rs[count.index].id
  peer_asn        = var.fgt_bgp-asn
  peer_ip         = var.fgt1_peer-ip
}

resource "azurerm_route_server_bgp_connection" "rs-spoke-bgp-fgt-passive" {
  count           = length(var.subnet_ids)
  name            = "${var.prefix}-bgp-fgt-passive"
  route_server_id = azurerm_route_server.rs[count.index].id
  peer_asn        = var.fgt_bgp-asn
  peer_ip         = var.fgt2_peer-ip
}