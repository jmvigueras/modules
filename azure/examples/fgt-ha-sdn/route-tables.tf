#-----------------------------------------------------------------------------
# Create necessary table route for access VNet spoke subnets
# - Create a table route for subnets VM in VNet spoke
# - RFC1918 ranges will be accessible through fortigate
#-----------------------------------------------------------------------------
resource "azurerm_route_table" "vnet-spoke-fgt_rt" {
  name                = "${var.prefix}-vnet-spoke-rt"
  location            = var.location
  resource_group_name = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
}

resource "azurerm_route" "vnet-spoke-fgt_default" {
  depends_on             = [module.fgt-ha]
  name                   = "default"
  resource_group_name    = var.resourcegroup_name == null ? azurerm_resource_group.rg[0].name : var.resourcegroup_name
  route_table_name       = azurerm_route_table.vnet-spoke-fgt_rt.name
  address_prefix         = "10.0.0.0/8"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-fgt.fgt-active-ni_ips["port3"]
}

// Route table association
resource "azurerm_subnet_route_table_association" "vnet-spoke-fgt_rt_association-1" {
  count          = length(local.vnet-spoke_cidrs)
  subnet_id      = module.vnet-spoke-fgt.subnet_ids["subnet_1"][count.index]
  route_table_id = azurerm_route_table.vnet-spoke-fgt_rt.id
}
resource "azurerm_subnet_route_table_association" "vnet-spoke-fgt_rt_association-2" {
  count          = length(local.vnet-spoke_cidrs)
  subnet_id      = module.vnet-spoke-fgt.subnet_ids["subnet_2"][count.index]
  route_table_id = azurerm_route_table.vnet-spoke-fgt_rt.id
}



