output "HUB-FGTCluster" {
  value = {
    admin           = local.adminusername
    pass            = local.adminpassword
    api_key         = module.fgt-ha.api_key
    active_mgmt     = "https://${module.vnet-fgt.fgt-active-mgmt-ip}:${local.admin_port}"
    passive_mgmt    = "https://${module.vnet-fgt.fgt-passive-mgmt-ip}:${local.admin_port}"
    advpn-ipsec-psk = module.fgt-ha.advpn-ipsec-psk
  }
}