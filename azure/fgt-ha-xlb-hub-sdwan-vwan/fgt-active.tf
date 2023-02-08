##############################################################################################################
# FGT ACTIVE VM
##############################################################################################################

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "advpn-ipsec-psk" {
  length  = 30
  special = false
  numeric = true
}

# Create and attach the eip to the units
resource "azurerm_virtual_machine" "fgt-active" {
  name                         = "${var.prefix}-fgt-active"
  location                     = var.location
  resource_group_name          = var.resourcegroup_name
  network_interface_ids        = var.fgt-active-ni_ids
  primary_network_interface_id = var.fgt-active-ni_ids[0]
  vm_size                      = var.size

  lifecycle {
    ignore_changes = [os_profile]
  }

  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.fgtversion
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "${var.prefix}-osDisk-fgt-active"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-fgt-active"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-active"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgt-active_all-config.rendered
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

data "template_file" "fgt-active_all-config" {
  template = file("${path.module}/templates/fgt-all.conf")
  vars = {
    type         = var.license_type
    license_file = var.license-active
    fgt_id       = "${var.hub["id"]}-active"
    fgt_priority = 200
    api_key      = random_string.api_key.result

    port1_ip   = cidrhost(var.fgt-subnet_cidrs["mgmt"], 10)
    port1_mask = cidrnetmask(var.fgt-subnet_cidrs["mgmt"])
    port1_gw   = cidrhost(var.fgt-subnet_cidrs["mgmt"], 1)
    port2_ip   = cidrhost(var.fgt-subnet_cidrs["public"], 10)
    port2_mask = cidrnetmask(var.fgt-subnet_cidrs["public"])
    port2_gw   = cidrhost(var.fgt-subnet_cidrs["public"], 1)
    port3_ip   = cidrhost(var.fgt-subnet_cidrs["private"], 10)
    port3_mask = cidrnetmask(var.fgt-subnet_cidrs["private"])
    port3_gw   = cidrhost(var.fgt-subnet_cidrs["private"], 1)
    peerip     = cidrhost(var.fgt-subnet_cidrs["mgmt"], 11)

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

data "template_file" "fgt_advpn-config" {
  template = file("${path.module}/templates/fgt-advpn.conf")
  vars = {
    hub_advpn-ip1   = cidrhost(var.hub["advpn-net"], 1)
    hub_advpn-ip2   = cidrhost(var.hub["advpn-net"], 2)
    advpn-ipsec-psk = random_string.advpn-ipsec-psk.result
  }
}

data "template_file" "fgt_bgp-config" {
  template = templatefile("${path.module}/templates/fgt-bgp.conf", {
    hub_advpn-ip1    = cidrhost(var.hub["advpn-net"], 1),
    hub_advpn-ip2    = cidrhost(var.hub["advpn-net"], 2),
    hub_advpn-net    = var.hub["advpn-net"],
    advpn-ipsec-psk  = random_string.advpn-ipsec-psk.result,
    hub_bgp-asn      = var.hub["bgp-asn"],
    hub_bgp-id       = cidrhost(var.hub["advpn-net"], 1),
    rs_peers         = var.rs_peers,
    vhub_peer        = var.vhub_peer,
    rs_bgp-asn       = var.rs_bgp-asn[0],
    spoke_bgp-asn    = var.spoke_bgp-asn
    spoke_cidr_vnet  = var.spoke_cidr_vnet
    spoke_cidr_site  = var.spoke_cidr_site
  })
}

data "template_file" "fgt_policy-config" {
  template = file("${path.module}/templates/fgt-policy.conf")
}

data "template_file" "fgt_gwlb-config" {
  template = file("${path.module}/templates/fgt-gwlb.conf")
  vars = {
    gwlb_ip = var.gwlb_ip
  }
}

data "template_file" "fgt_vxlan-config" {
  template = file("${path.module}/templates/fgt-vxlan.conf")
  vars = {
    vni          = var.hub-peer_vxlan["vni"]
    public-ip    = var.hub-peer_vxlan["public-ip"]
    remote-ip    = var.hub-peer_vxlan["remote-ip"]
    local-ip     = var.hub-peer_vxlan["local-ip"]
    bgp-asn      = var.hub-peer_vxlan["bgp-asn"]
    port_vxlan   = "port2"
    port_private = "port3"
  }
}