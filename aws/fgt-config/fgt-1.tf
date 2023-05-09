##############################################################################################################
# FGT ACTIVE VM
##############################################################################################################
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
    fgt_id         = var.config_spoke ? "${var.spoke["id"]}-1" : "${var.hub[0]["id"]}-1"
    admin_port     = var.admin_port
    admin_cidr     = var.admin_cidr
    adminusername  = "admin"
    type           = var.license_type
    license_file   = var.license_file_1
    rsa-public-key = trimspace(var.rsa-public-key)
    api_key        = var.api_key == null ? random_string.api_key.result : var.api_key

    public_port  = var.public_port
    public_ip    = var.fgt-active-ni_ips["public"]
    public_mask  = cidrnetmask(var.subnet_active_cidrs["public"])
    public_gw    = cidrhost(var.subnet_active_cidrs["public"], 1)
    private_port = var.private_port
    private_ip   = var.fgt-active-ni_ips["private"]
    private_mask = cidrnetmask(var.subnet_active_cidrs["private"])
    private_gw   = cidrhost(var.subnet_active_cidrs["private"], 1)
    mgmt_port    = var.mgmt_port
    mgmt_ip      = var.fgt-active-ni_ips["mgmt"]
    mgmt_mask    = cidrnetmask(var.subnet_active_cidrs["mgmt"])
    mgmt_gw      = cidrhost(var.subnet_active_cidrs["mgmt"], 1)

    fgt_sdn-config         = data.template_file.fgt_sdn-config.rendered
    fgt_ha-fgcp-config     = var.config_fgcp ? data.template_file.fgt_ha-fgcp-active-config.rendered : ""
    fgt_ha-fgsp-config     = var.config_fgsp ? data.template_file.fgt_ha-fgsp-active-config.rendered : ""
    fgt_bgp-config         = data.template_file.fgt_bgp-config.rendered
    fgt_static-config      = var.vpc-spoke_cidr != null ? data.template_file.fgt_active_static-config.rendered : ""
    fgt_sdwan-config       = var.config_spoke ? join("\n", data.template_file.fgt_active_sdwan-config.*.rendered) : ""
    fgt_tgw-gre-config     = var.config_tgw-gre ? data.template_file.fgt_active_tgw-gre-config.rendered : ""
    fgt_vxlan-config       = var.config_vxlan ? data.template_file.fgt_vxlan-config.rendered : ""
    fgt_vpn-config         = var.config_hub ? join("\n", data.template_file.fgt_active_vpn-config.*.rendered) : ""
    fgt_gwlb-geneve-config = var.config_gwlb-geneve ? data.template_file.fgt_active_gwlb-geneve-config.rendered : ""
    fgt_fmg-config         = var.config_fmg ? data.template_file.fgt_1_fmg-config.rendered : ""
    fgt_faz-config         = var.config_faz ? data.template_file.fgt_1_faz-config.rendered : ""
    fgt_extra-config       = var.fgt_active_extra-config
  }
}

data "template_file" "fgt_sdn-config" {
  template = file("${path.module}/templates/aws_fgt-sdn.conf")
}

data "template_file" "fgt_ha-fgcp-active-config" {
  template = file("${path.module}/templates/aws_fgt-ha-fgcp.conf")
  vars = {
    fgt_priority = 200
    ha_port      = var.mgmt_port
    ha_gw        = cidrhost(var.subnet_active_cidrs["mgmt"], 1)
    peerip       = var.fgt-passive-ni_ips["mgmt"]
  }
}

data "template_file" "fgt_ha-fgsp-active-config" {
  template = file("${path.module}/templates/aws_fgt-ha-fgsp.conf")
  vars = {
    mgmt_port     = var.mgmt_port
    mgmt_gw       = cidrhost(var.subnet_active_cidrs["mgmt"], 1)
    peerip        = var.fgt-passive-ni_ips["mgmt"]
    master_secret = random_string.fgsp_auto-config_secret.result
    master_ip     = ""
  }
}

data "template_file" "fgt_active_sdwan-config" {
  count    = var.hubs != null ? length(var.hubs) : 0
  template = file("${path.module}/templates/fgt-sdwan.conf")
  vars = {
    hub_id            = var.hubs[count.index]["id"]
    hub_ipsec_id      = "${var.hubs[count.index]["id"]}_ipsec_${count.index + 1}"
    hub_vpn_psk       = var.hubs[count.index]["vpn_psk"] == "" ? random_string.vpn_psk.result : var.hubs[count.index]["vpn_psk"]
    hub_external_ip   = var.hubs[count.index]["external_ip"]
    hub_private_ip    = var.hubs[count.index]["hub_ip"]
    site_private_ip   = var.hubs[count.index]["site_ip"]
    hub_bgp_asn       = var.hubs[count.index]["bgp_asn"]
    hck_ip            = var.hubs[count.index]["hck_ip"]
    hub_cidr          = var.hubs[count.index]["cidr"]
    network_id        = var.hubs[count.index]["network_id"]
    ike_version       = var.hubs[count.index]["ike_version"]
    dpd_retryinterval = var.hubs[count.index]["dpd_retryinterval"]
    local_id          = "${var.spoke["id"]}-1"
    local_bgp_asn     = var.spoke["bgp-asn"]
    local_router_id   = var.fgt-active-ni_ips["mgmt"]
    local_network     = var.spoke["cidr"]
    sdwan_port        = var.ports[var.hubs[count.index]["sdwan_port"]]
    private_port      = var.ports["private"]
    count             = count.index + 1
  }
}

data "template_file" "fgt_active_vpn-config" {
  count    = length(var.hub)
  template = file("${path.module}/templates/fgt-vpn.conf")
  vars = {
    hub_private_ip        = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, 0), 1)
    hub_remote_ip         = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, 0), 2)
    network_id            = var.hub[count.index]["network_id"]
    ike_version           = var.hub[count.index]["ike_version"]
    dpd_retryinterval     = var.hub[count.index]["dpd_retryinterval"]
    local_id              = var.hub[count.index]["id"]
    local_bgp_asn         = var.hub[count.index]["bgp_asn_hub"]
    local_router-id       = var.fgt-active-ni_ips["mgmt"]
    local_network         = var.hub[count.index]["cidr"]
    mode_cfg              = var.hub[count.index]["mode_cfg"]
    site_private_ip_start = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, 0), 3)
    site_private_ip_end   = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, 0), 14)
    site_private_ip_mask  = cidrnetmask(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, 0))
    site_bgp_asn          = var.hub[count.index]["bgp_asn_spoke"]
    vpn_psk               = var.hub[count.index]["vpn_psk"] == "" ? random_string.vpn_psk.result : var.hub[count.index]["vpn_psk"]
    vpn_cidr              = cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, 0)
    vpn_port              = var.ports[var.hub[count.index]["vpn_port"]]
    vpn_name              = "vpn-${var.hub[count.index]["vpn_port"]}"
    private_port          = var.ports["private"]
    // route_map_out         = "rm_out_aspath_0"
    route_map_out = ""
    count         = count.index + 1
  }
}

data "template_file" "fgt_bgp-config" {
  template = file("${path.module}/templates/fgt-bgp.conf")
  vars = {
    bgp_asn   = var.config_hub ? var.hub[0]["bgp_asn_hub"] : var.config_spoke ? var.spoke["bgp-asn"] : var.bgp_asn_default
    router_id = var.fgt-active-ni_ips["mgmt"]
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

data "template_file" "fgt_active_static-config" {
  template = templatefile("${path.module}/templates/fgt-static.conf", {
    vpc-spoke_cidr = var.vpc-spoke_cidr
    port           = var.private_port
    gw             = cidrhost(var.subnet_active_cidrs["private"], 1)
  })
}

data "template_file" "fgt_active_tgw-gre-config" {
  template = file("${path.module}/templates/aws_fgt-tgw.conf")
  vars = {
    interface_name   = var.tgw_gre_interface_name
    bgp-asn          = var.tgw_bgp-asn
    port             = var.private_port
    port_gw          = cidrhost(var.subnet_active_cidrs["private"], 1)
    tunnel_local_ip  = var.fgt-active-ni_ips["private"]
    remote_cidr      = var.tgw_cidr[0]
    tunnel_remote_ip = cidrhost(var.tgw_cidr[0], 10)
    local_ip         = cidrhost(var.tgw_inside_cidr[0], 1)
    remote_ip_1      = cidrhost(var.tgw_inside_cidr[0], 2)
    remote_ip_2      = cidrhost(var.tgw_inside_cidr[0], 3)
    route_map_out    = var.config_fgsp ? "rm_out_aspath_0" : ""
    public_port      = var.public_port
    local_bgp-asn    = var.config_hub ? var.hub[0]["bgp_asn_hub"] : var.config_spoke ? var.spoke["bgp-asn"] : var.bgp_asn_default
  }
}

data "template_file" "fgt_active_gwlb-geneve-config" {
  template = templatefile("${path.module}/templates/aws_fgt-gwlb-geneve.conf", {
    gwlbe_ip_az1    = var.gwlbe_ip[0]
    gwlbe_ip_az2    = var.gwlbe_ip[1]
    subnet-az1-gwlb = var.subnet_active_cidrs["gwlb"]
    subnet-az2-gwlb = var.subnet_passive_cidrs["gwlb"]
    private_port    = var.private_port
    public_port     = var.public_port
    private_gw      = cidrhost(var.subnet_active_cidrs["private"], 1)
    e-w_cidrs       = var.gwlb_e-w_cidrs
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