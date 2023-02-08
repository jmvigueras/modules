###################################
#Create Internal LB
##################################

// Create Load Balancer
resource "azurerm_lb" "ilb" {
  name                = "${var.prefix}-InternalLoadBalancer"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                          = "${var.prefix}-ilb-front-ip"
    subnet_id                     = var.subnet_private["id"]
    private_ip_address            = cidrhost(var.subnet_private["cidr"], 9)
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "ilbbackend" {
  loadbalancer_id = azurerm_lb.ilb.id
  name            = "BackEndPool"
}

resource "azurerm_lb_probe" "ilbprobe" {
  loadbalancer_id     = azurerm_lb.ilb.id
  name                = "lbprobe"
  port                = var.backend-probe_port
  interval_in_seconds = 5
  number_of_probes    = 2
  protocol            = "Tcp"
}

resource "azurerm_lb_rule" "lb_haports_rule" {
  loadbalancer_id                = azurerm_lb.ilb.id
  name                           = "lb_haports_rule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "${var.prefix}-ilb-front-ip"
  probe_id                       = azurerm_lb_probe.ilbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilbbackend.id]
}

resource "azurerm_network_interface_backend_address_pool_association" "fgt1-ilb-backendpool" {
  network_interface_id    = var.fgt-ni_ids["fgt1_private"]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilbbackend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "fgt2-ilb-backendpool" {
  network_interface_id    = var.fgt-ni_ids["fgt2_private"]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilbbackend.id
}


