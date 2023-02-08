output "Site-FGT" {
  value = {
    admin    = var.adminusername
    pass     = var.adminpassword
    api_key  = random_string.api_key.result
    url_mgmt = "https://${azurerm_public_ip.site-fgt-mgmt-ip.ip_address}:${var.admin_port}"
  }
}