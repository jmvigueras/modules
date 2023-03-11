###################################
#Create External LB
##################################

resource "azurerm_public_ip" "elb_pip" {
  name                = "${var.prefix}-elb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = format("%s-%s", lower(var.prefix), "elb-pip")
}

resource "azurerm_lb" "elb" {
  name                = "${var.prefix}-ExternalLoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "${var.prefix}-elb-frontend"
    public_ip_address_id = azurerm_public_ip.elb_pip.id
  }
}

resource "azurerm_lb_probe" "elb_probe" {
  loadbalancer_id     = azurerm_lb.elb.id
  name                = "lbprobe"
  port                = var.backend-probe_port
  interval_in_seconds = 5
  number_of_probes    = 2
  protocol            = "Tcp"
}

resource "azurerm_lb_backend_address_pool" "elb_backend" {
  loadbalancer_id = azurerm_lb.elb.id
  name            = "BackEndPool"
}

// Create BackEnd Pools associate to Fortigate IPs
resource "azurerm_lb_backend_address_pool_address" "elb_backend_fgt_1" {
  name                    = "BackEndPool-fgt-1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_backend.id
  virtual_network_id      = var.vnet-fgt["id"]
  ip_address              = var.fgt-active-ni_ips["public"]
}
resource "azurerm_lb_backend_address_pool_address" "elb_backend_fgt_2" {
  name                    = "BackEndPool-fgt-2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_backend.id
  virtual_network_id      = var.vnet-fgt["id"]
  ip_address              = var.fgt-passive-ni_ips["public"]
}

// Create Load Balancing Rules
resource "azurerm_lb_rule" "lbrule-tcp80" {
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "lbrule-http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.prefix}-elb-frontend"
  probe_id                       = azurerm_lb_probe.elb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_backend.id]
}
resource "azurerm_lb_rule" "lbrule-upd500" {
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "lbrule-udp500"
  protocol                       = "Udp"
  frontend_port                  = 500
  backend_port                   = 500
  frontend_ip_configuration_name = "${var.prefix}-elb-frontend"
  probe_id                       = azurerm_lb_probe.elb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_backend.id]
}
resource "azurerm_lb_rule" "lbrule-udp4500" {
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "lbrule-udp4500"
  protocol                       = "Udp"
  frontend_port                  = 4500
  backend_port                   = 4500
  frontend_ip_configuration_name = "${var.prefix}-elb-frontend"
  probe_id                       = azurerm_lb_probe.elb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_backend.id]
}
resource "azurerm_lb_rule" "lbrule-udp4789" {
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "lbrule-udp4789"
  protocol                       = "Udp"
  frontend_port                  = 4789
  backend_port                   = 4789
  frontend_ip_configuration_name = "${var.prefix}-elb-frontend"
  probe_id                       = azurerm_lb_probe.elb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_backend.id]
}

/*
// Create Load Balancing Rules associate to FGT NICs
resource "azurerm_network_interface_backend_address_pool_association" "fgt1-elb-backendpool" {
  network_interface_id    = var.fgt-ni_ids["fgt1_public"]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_backend.id
}
resource "azurerm_network_interface_backend_address_pool_association" "fgt2-elb-backendpool" {
  network_interface_id    = var.fgt-ni_ids["fgt2_public"]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_backend.id
}
*/