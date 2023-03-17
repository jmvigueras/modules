######################################################
# Create peering to VNET FGT
######################################################
resource "azurerm_virtual_network_peering" "peerSpoketoFGT-1" {
  name                      = "peer-spoke-to-FGT-1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.vnet-fgt["name"]
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpoketoFGT-2" {
  name                      = "peer-spoke-to-FGT-2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id = var.vnet-fgt["id"]
  allow_forwarded_traffic   = true
}