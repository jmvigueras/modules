######################################################
# Create peering to VNET FGT
######################################################
resource "azurerm_virtual_network_peering" "peerSpoketoFGT-1" {
  count                     = var.vnet-fgt == null ? 0 : length(var.vnet-spoke_cidrs)
  name                      = "peer-spoke-${count.index + 1}-to-FGT-1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.vnet-fgt["name"]
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke[count.index].id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpoketoFGT-2" {
  count                     = var.vnet-fgt == null ? 0 : length(var.vnet-spoke_cidrs)
  name                      = "peer-spoke-${count.index + 1}-to-FGT-2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke[count.index].name
  remote_virtual_network_id = var.vnet-fgt["id"]
  allow_forwarded_traffic   = true
}