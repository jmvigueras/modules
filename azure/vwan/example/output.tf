output "vhub_bgp-asn" {
  value = module.vwan.bgp-asn
}

output "vhub_default-route-table_id" {
  value = module.vwan.default-route-table_id
}

output "vhub_virtual_router_ips" {
  value = module.vwan.virtual_router_ips
}