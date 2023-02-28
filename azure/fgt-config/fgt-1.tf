#-------------------------------------------------------------------------------------------------------------
# FGT ACTIVE VM
#-------------------------------------------------------------------------------------------------------------
# Create new random API key to be provisioned in FortiGates.
resource "random_string" "vpn_psk" {
  length  = 30
  special = false
  numeric = true
}
# Create new random FGSP secret
resource "random_string" "fgsp_auto-config_secret" {
  length  = 10
  special = false
  numeric = true
}
# Create new random FGSP secret
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}

data "template_file" "fgt_active" {
  template = file("${path.module}/templates/fgt-all.conf")

  vars = {
    fgt_id         = var.config_spoke ? "${var.spoke["id"]}-1" : "${var.hub["id"]}-1"
    admin_port     = var.admin_port
    admin_cidr     = var.admin_cidr
    adminusername  = "admin"
    type           = var.license_type
    license_file   = var.license_file_1
    rsa-public-key = trimspace(var.rsa-public-key)
    api_key        = var.api_key == null ? random_string.api_key.result : var.api_key

    public_port  = var.public_port
    public_ip    = var.fgt-active-ni_ips["public"]
    public_mask  = cidrnetmask(var.subnet_cidrs["public"])
    public_gw    = cidrhost(var.subnet_cidrs["public"], 1)
    private_port = var.private_port
    private_ip   = var.fgt-active-ni_ips["private"]
    private_mask = cidrnetmask(var.subnet_cidrs["private"])
    private_gw   = cidrhost(var.subnet_cidrs["private"], 1)
    mgmt_port    = var.mgmt_port
    mgmt_ip      = var.fgt-active-ni_ips["mgmt"]
    mgmt_mask    = cidrnetmask(var.subnet_cidrs["mgmt"])
    mgmt_gw      = cidrhost(var.subnet_cidrs["mgmt"], 1)

    fgt_sdn-config        = data.template_file.fgt_sdn-config.rendered
    fgt_ha-fgcp-config    = var.config_fgcp ? data.template_file.fgt_ha-fgcp-active-config.rendered : ""
    fgt_ha-fgsp-config    = var.config_fgsp ? data.template_file.fgt_ha-fgsp-active-config.rendered : ""
    fgt_bgp-config        = var.config_spoke || var.config_hub ? "" : data.template_file.fgt_bgp-config.rendered
    fgt_static-config     = var.vpc-spoke_cidr != null ? data.template_file.fgt_static-config.rendered : ""
    fgt_sdwan-config      = var.config_spoke ? join("\n", data.template_file.fgt_sdwan-config.*.rendered) : ""
    fgt_vpn-config        = var.config_hub ? data.template_file.fgt_vpn-config.0.rendered : ""
    fgt_vxlan-config      = var.config_vxlan ? data.template_file.fgt_vxlan-config.rendered : ""
    fgt_vhub-config       = var.config_vhub ? data.template_file.fgt_vhub-config.0.rendered : ""
    fgt_ars-config        = var.config_ars ? data.template_file.fgt_ars-config.0.rendered : ""
    fgt_gwlb-vxlan-config = var.config_gwlb-vxlan ? data.template_file.fgt_gwlb-vxlan-config.rendered : ""
    fgt_fmg-config        = var.config_fmg ? data.template_file.fgt_1_fmg-config.rendered : ""
    fgt_faz-config        = var.config_faz ? data.template_file.fgt_1_faz-config.rendered : ""
    fgt_extra-config      = var.fgt_active_extra-config
  }
}

data "template_file" "fgt_sdn-config" {
  template = file("${path.module}/templates/az_fgt-sdn.conf")
  vars = {
    tenant              = var.tenant_id
    subscription        = var.subscription_id
    clientid            = var.client_id
    clientsecret        = var.client_secret
    resource_group_name = var.resource_group_name
  }
}

data "template_file" "fgt_ha-fgcp-active-config" {
  template = file("${path.module}/templates/fgt-ha-fgcp.conf")
  vars = {
    fgt_priority = 200
    mgmt_port    = var.mgmt_port
    ha_port      = var.ha_port
    mgmt_gw      = cidrhost(var.subnet_cidrs["mgmt"], 1)
    peerip       = var.fgt-passive-ni_ips["mgmt"]
  }
}

data "template_file" "fgt_ha-fgsp-active-config" {
  template = file("${path.module}/templates/fgt-ha-fgsp.conf")
  vars = {
    mgmt_port     = var.mgmt_port
    mgmt_gw       = cidrhost(var.subnet_cidrs["mgmt"], 1)
    peerip        = var.fgt-passive-ni_ips["mgmt"]
    master_secret = random_string.fgsp_auto-config_secret.result
    master_ip     = ""
  }
}

data "template_file" "fgt_sdwan-config" {
  count    = var.hubs != null ? length(var.hubs) : 0
  template = file("${path.module}/templates/fgt-sdwan.conf")
  vars = {
    hub_id            = var.hubs[count.index]["id"]
    hub_ipsec-id      = "${var.hubs[count.index]["id"]}_ipsec_${count.index + 1}"
    hub_vpn_psk       = var.hubs[count.index]["vpn_psk"]
    hub_public-ip     = var.hubs[count.index]["public-ip"]
    hub_private-ip    = var.hubs[count.index]["hub-ip"]
    site_private-ip   = var.hubs[count.index]["site-ip"]
    hub_bgp-asn       = var.hubs[count.index]["bgp-asn"]
    hck-srv-ip        = var.hubs[count.index]["hck-srv-ip"]
    hub_cidr          = var.hubs[count.index]["cidr"]
    network_id        = var.hubs[count.index]["network_id"]
    ike-version       = var.hubs[count.index]["ike-version"]
    dpd-retryinterval = var.hubs[count.index]["dpd-retryinterval"]
    localid           = var.spoke["id"]
    local_bgp-asn     = var.spoke["bgp-asn"]
    local_router-id   = var.fgt-active-ni_ips["mgmt"]
    local_network     = var.spoke["cidr"]
    sdwan_port        = var.public_port
    private_port      = var.private_port
    count             = count.index + 1
  }
}

data "template_file" "fgt_vpn-config" {
  count    = var.config_fgsp ? 2 : 1
  template = file("${path.module}/templates/fgt-vpn.conf")
  vars = {
    hub_private-ip        = cidrhost(cidrsubnet(var.hub["vpn_cidr"], 1, count.index), 1)
    network_id            = var.hub["network_id"]
    ike-version           = var.hub["ike-version"]
    dpd-retryinterval     = var.hub["dpd-retryinterval"]
    localid               = var.hub["id"]
    local_bgp-asn         = var.hub["bgp-asn_hub"]
    local_router-id       = var.fgt-active-ni_ips["mgmt"]
    local_network         = var.hub["cidr"]
    mode-cfg              = var.hub["mode-cfg"]
    site_private-ip_start = cidrhost(cidrsubnet(var.hub["vpn_cidr"], 1, count.index), 2)
    site_private-ip_end   = cidrhost(cidrsubnet(var.hub["vpn_cidr"], 1, count.index), 14)
    site_private-ip_mask  = cidrnetmask(cidrsubnet(var.hub["vpn_cidr"], 1, count.index))
    site_bgp-asn          = var.hub["bgp-asn_spoke"]
    vpn_psk               = var.hub["vpn_psk"] == "" ? random_string.vpn_psk.result : var.hub["vpn_psk"]
    vpn_cidr              = cidrsubnet(var.hub["vpn_cidr"], 1, count.index)
    vpn_port              = var.public_port
    private_port          = var.private_port
    route_map_out         = "rm_prepending_out_${count.index}"
  }
}

data "template_file" "fgt_bgp-config" {
  template = file("${path.module}/templates/fgt-bgp.conf")
  vars = {
    bgp-asn   = var.bgp-asn_default
    router-id = var.fgt-active-ni_ips["mgmt"]
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
    vxlan_port   = var.public_port
    private_port = var.private_port
  }
}

data "template_file" "fgt_static-config" {
  template = templatefile("${path.module}/templates/fgt-static.conf", {
    vpc-spoke_cidr = var.vpc-spoke_cidr
    port           = var.private_port
    gw             = cidrhost(var.subnet_cidrs["private"], 1)
  })
}

data "template_file" "fgt_gwlb-vxlan-config" {
  template = file("${path.module}/templates/az_fgt-gwlb-vxlan.conf")
  vars = {
    gwlb_ip      = var.gwlb_ip
    vdi_ext      = var.gwlb_vxlan["vdi_ext"]
    vdi_int      = var.gwlb_vxlan["vdi_int"]
    port_ext     = var.gwlb_vxlan["port_ext"]
    port_int     = var.gwlb_vxlan["port_int"]
    private_port = var.private_port
  }
}

data "template_file" "fgt_vhub-config" {
  count = var.config_fgsp ? 2 : 1
  template = templatefile("${path.module}/templates/az_fgt-vhub.conf", {
    vhub_peer       = var.vhub_peer
    vhub_bgp-asn    = var.vhub_bgp-asn[0]
    local_bgp-asn   = var.config_hub ? var.hub["bgp-asn_hub"] : var.config_spoke ? var.spoke["bgp-asn"] : var.bgp-asn_default
    local_router-id = var.fgt-active-ni_ips["mgmt"]
    route_map_out   = "rm_prepending_out_${count.index}"
  })
}

data "template_file" "fgt_ars-config" {
  count = var.config_fgsp ? 2 : 1
  template = templatefile("${path.module}/templates/az_fgt-ars.conf", {
    rs_peers        = var.rs_peer
    rs_bgp-asn      = var.rs_bgp-asn[0]
    local_bgp-asn   = var.config_hub ? var.hub["bgp-asn_hub"] : var.config_spoke ? var.spoke["bgp-asn"] : var.bgp-asn_default
    local_router-id = var.fgt-active-ni_ips["mgmt"]
    route_map_out   = "rm_prepending_out_${count.index}"
  })
}

data "template_file" "fgt_1_faz-config" {
  template = file("${path.module}/templates/fgt-faz.conf")
  vars = {
    ip                      = var.faz_ip
    sn                      = var.faz_sn
    source-ip               = var.faz_fgt-1_source-ip
    interface-select-method = var.faz_interface-select-method
  }
}

data "template_file" "fgt_1_fmg-config" {
  template = file("${path.module}/templates/fgt-fmg.conf")
  vars = {
    ip                      = var.fmg_ip
    sn                      = var.fmg_sn
    source-ip               = var.fmg_fgt-1_source-ip
    interface-select-method = var.fmg_interface-select-method
  }
}