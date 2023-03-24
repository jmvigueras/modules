#------------------------------------------------------------------------
# Create Internal LB
#------------------------------------------------------------------------

// Create Load Balancer
resource "azurerm_lb" "ilb" {
  name                = "${var.prefix}-InternalLoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                          = "${var.prefix}-ilb-frontend"
    subnet_id                     = var.subnet_ids["private"]
    private_ip_address            = var.ilb_ip != null ? var.ilb_ip : cidrhost(var.subnet_cidrs["private"], 9)
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "ilb_backend" {
  loadbalancer_id = azurerm_lb.ilb.id
  name            = "BackEndPool"
}

// Create BackEnd Pools associate to Fortigate IPs
resource "azurerm_lb_backend_address_pool_address" "ilb_backend_fgt_1" {
  name                    = "BackEndPool-fgt-1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_backend.id
  virtual_network_id      = var.vnet-fgt["id"]
  ip_address              = var.fgt-active-ni_ips["private"]
}
resource "azurerm_lb_backend_address_pool_address" "ilb_backend_fgt_2" {
  name                    = "BackEndPool-fgt-2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_backend.id
  virtual_network_id      = var.vnet-fgt["id"]
  ip_address              = var.fgt-passive-ni_ips["private"]
}

resource "azurerm_lb_probe" "ilb_probe" {
  loadbalancer_id     = azurerm_lb.ilb.id
  name                = "lbprobe"
  port                = var.backend-probe_port
  interval_in_seconds = 5
  number_of_probes    = 2
  protocol            = "Tcp"
}

resource "azurerm_lb_rule" "ilb_rule_haport" {
  loadbalancer_id                = azurerm_lb.ilb.id
  name                           = "ilb-rule-haport"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "${var.prefix}-ilb-frontend"
  probe_id                       = azurerm_lb_probe.ilb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilb_backend.id]
  load_distribution              = "SourceIP"
}

/*
resource "azurerm_network_interface_backend_address_pool_association" "fgt1-ilb-backendpool" {
  network_interface_id    = var.fgt-ni_ids["fgt1_private"]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_backend.id
}
resource "azurerm_network_interface_backend_address_pool_association" "fgt2-ilb-backendpool" {
  network_interface_id    = var.fgt-ni_ids["fgt2_private"]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_backend.id
}
*/

