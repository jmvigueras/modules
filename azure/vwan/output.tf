output "bgp-asn" {
  value = azurerm_virtual_hub.vhub.virtual_router_asn
}

output "default-route-table_id" {
  value = azurerm_virtual_hub.vhub.default_route_table_id
}

output "virtual_router_ips" {
  value = azurerm_virtual_hub.vhub.virtual_router_ips
}

output "virtual_hub_id" {
  value = azurerm_virtual_hub.vhub.id
}

output "vwan_id" {
  value = azurerm_virtual_wan.vwan.id
}