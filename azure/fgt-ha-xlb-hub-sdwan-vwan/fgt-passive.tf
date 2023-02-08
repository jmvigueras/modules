##############################################################################################################
# FGT PASSIVE VM
##############################################################################################################

resource "azurerm_virtual_machine" "fgt-passive" {
  name                         = "${var.prefix}-fgt-passive"
  location                     = var.location
  resource_group_name          = var.resourcegroup_name
  network_interface_ids        = var.fgt-passive-ni_ids
  primary_network_interface_id = var.fgt-passive-ni_ids[0]
  vm_size                      = var.size

  lifecycle {
    ignore_changes = [os_profile]
  }

  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.fgtversion
    id        = null
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "${var.prefix}-osDisk-fgt-passive"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-fgt-passive"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-passive"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgt-passive_all-config.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.storage-account_endpoint
  }

  tags = var.tags
}

data "template_file" "fgt-passive_all-config" {
  template = file("${path.module}/templates/fgt-all.conf")
  vars = {
    type         = var.license_type
    license_file = var.license-active
    fgt_id       = "${var.hub["id"]}-passive"
    fgt_priority = 100
    api_key      = random_string.api_key.result

    port1_ip   = cidrhost(var.fgt-subnet_cidrs["mgmt"], 11)
    port1_mask = cidrnetmask(var.fgt-subnet_cidrs["mgmt"])
    port1_gw   = cidrhost(var.fgt-subnet_cidrs["mgmt"], 1)
    port2_ip   = cidrhost(var.fgt-subnet_cidrs["public"], 11)
    port2_mask = cidrnetmask(var.fgt-subnet_cidrs["public"])
    port2_gw   = cidrhost(var.fgt-subnet_cidrs["public"], 1)
    port3_ip   = cidrhost(var.fgt-subnet_cidrs["private"], 11)
    port3_mask = cidrnetmask(var.fgt-subnet_cidrs["private"])
    port3_gw   = cidrhost(var.fgt-subnet_cidrs["private"], 1)
    peerip     = cidrhost(var.fgt-subnet_cidrs["mgmt"], 10)

    tenant       = var.tenant_id
    subscription = var.subscription_id
    clientid     = var.client_id
    clientsecret = var.client_secret
    admin_port   = var.admin_port
    admin_cidr   = var.admin_cidr
    rsg          = var.resourcegroup_name

    spoke_cidr_vnet = var.spoke_cidr_vnet

    fgt_advpn-config  = var.hub != null ? data.template_file.fgt_advpn-config.rendered : ""
    fgt_gwlb-config   = var.gwlb_ip != null ? data.template_file.fgt_gwlb-config.rendered : ""
    fgt_bgp-config    = var.hub != null ? data.template_file.fgt_bgp-config.rendered : ""
    fgt_policy-config = data.template_file.fgt_policy-config.rendered
    fgt_vxlan-config  = var.hub-peer_vxlan != null && var.hub != null ? data.template_file.fgt_vxlan-config.rendered : ""
  }
}