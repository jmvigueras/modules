##############################################################################################################
# FGT PASSIVE VM
##############################################################################################################

data "template_file" "fgt_2" {
  template = file("${path.module}/templates/fgt_all.conf")

  vars = {
    fgt_id         = var.config_spoke ? "${var.spoke["id"]}-2" : "${var.hub[0]["id"]}-2"
    admin_port     = var.admin_port
    admin_cidr     = var.admin_cidr
    adminusername  = "admin"
    type           = var.license_type
    license_file   = var.license_file_2
    fortiflex_token = var.fortiflex_token_2
    rsa_public_key = var.rsa_public_key
    api_key        = var.api_key

    public_port  = var.public_port
    public_ip    = var.fgt_2_ips["public"]
    public_mask  = cidrnetmask(var.fgt_subnet_cidrs["public"])
    public_gw    = cidrhost(var.fgt_subnet_cidrs["public"], 1)
    private_port = var.private_port
    private_ip   = var.fgt_2_ips["private"]
    private_mask = cidrnetmask(var.fgt_subnet_cidrs["private"])
    private_gw   = cidrhost(var.fgt_subnet_cidrs["private"], 1)
    mgmt_port    = var.mgmt_port
    mgmt_ip      = var.fgt_2_ips["mgmt"]
    mgmt_mask    = cidrnetmask(var.fgt_subnet_cidrs["mgmt"])
    mgmt_gw      = cidrhost(var.fgt_subnet_cidrs["mgmt"], 1)

    config_sdn           = data.template_file.config_sdn.rendered
    config_ha_fgcp       = var.config_fgcp ? data.template_file.config_ha_fgcp_fgt_2.rendered : ""
    config_ha_fgsp       = var.config_fgsp ? data.template_file.config_ha_fgsp_fgt_2.rendered : ""
    config_router_bgp    = data.template_file.config_router_bgp.rendered
    config_router_static = var.vcn_spoke_cidrs != null ? data.template_file.config_router_static.rendered : ""
    config_sdwan         = var.config_spoke ? var.config_fgsp ? join("\n", data.template_file.config_sdwan_fgt_2.*.rendered) : join("\n", data.template_file.config_sdwan_fgt_1.*.rendered) : ""
    config_vxlan         = var.config_vxlan ? data.template_file.config_vxlan.rendered : ""
    config_vpn           = var.config_hub ? join("\n", data.template_file.config_vpn_fgt_2.*.rendered) : ""
    config_fmg           = var.config_fmg ? data.template_file.config_fmg_fgt_2.rendered : ""
    config_faz           = var.config_faz ? data.template_file.config_faz_fgt_2.rendered : ""
    config_extra         = var.config_extra_fgt_2
  }
}

data "template_file" "config_ha_fgcp_fgt_2" {
  template = file("${path.module}/templates/oci_fgt_ha_fgcp.conf")
  vars = {
    fgt_priority = 100
    ha_port      = var.mgmt_port
    ha_gw        = cidrhost(var.fgt_subnet_cidrs["mgmt"], 1)
    peerip       = var.fgt_1_ips["mgmt"]
  }
}

data "template_file" "config_ha_fgsp_fgt_2" {
  template = file("${path.module}/templates/oci_fgt_ha_fgsp.conf")
  vars = {
    mgmt_port     = var.mgmt_port
    mgmt_gw       = cidrhost(var.fgt_subnet_cidrs["mgmt"], 1)
    peerip        = var.fgt_1_ips["mgmt"]
    master_secret = random_string.fgsp_auto-config_secret.result
    master_ip     = var.fgt_1_ips["mgmt"]
  }
}

data "template_file" "config_sdwan_fgt_2" {
  count    = var.hubs != null ? length(var.hubs) : 0
  template = file("${path.module}/templates/fgt_sdwan.conf")
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
    local_id          = "${var.spoke["id"]}-2"
    local_bgp_asn     = var.spoke["bgp_asn"]
    local_router_id   = var.fgt_2_ips["mgmt"]
    local_network     = var.spoke["cidr"]
    sdwan_port        = var.ports[var.hubs[count.index]["sdwan_port"]]
    private_port      = var.ports["private"]
    count             = count.index + 1
  }
}

data "template_file" "config_vpn_fgt_2" {
  count    = length(var.hub)
  template = file("${path.module}/templates/fgt_vpn.conf")
  vars = {
    hub_private_ip        = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, var.config_fgsp ? 1 : 0), 1)
    hub_remote_ip         = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, var.config_fgsp ? 1 : 0), 2)
    network_id            = var.hub[count.index]["network_id"]
    ike_version           = var.hub[count.index]["ike_version"]
    dpd_retryinterval     = var.hub[count.index]["dpd_retryinterval"]
    local_id              = var.hub[count.index]["id"]
    local_bgp_asn         = var.hub[count.index]["bgp_asn_hub"]
    local_network         = var.hub[count.index]["cidr"]
    mode_cfg              = var.hub[count.index]["mode_cfg"]
    site_private_ip_start = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, var.config_fgsp ? 1 : 0), 3)
    site_private_ip_end   = cidrhost(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, var.config_fgsp ? 1 : 0), 14)
    site_private_ip_mask  = cidrnetmask(cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, var.config_fgsp ? 1 : 0))
    site_bgp_asn          = var.hub[count.index]["bgp_asn_spoke"]
    vpn_psk               = var.hub[count.index]["vpn_psk"] == "" ? random_string.vpn_psk.result : var.hub[count.index]["vpn_psk"]
    vpn_cidr              = cidrsubnet(var.hub[count.index]["vpn_cidr"], 1, var.config_fgsp ? 1 : 0)
    vpn_port              = var.ports[var.hub[count.index]["vpn_port"]]
    vpn_name              = "vpn-${var.hub[count.index]["vpn_port"]}"
    private_port          = var.ports["private"]
    // route_map_out         = "rm_out_aspath_${var.config_fgsp ? 1 : 0}"
    route_map_out = ""
    count         = count.index + 1
  }
}

data "template_file" "config_faz_fgt_2" {
  template = file("${path.module}/templates/fgt_faz.conf")
  vars = {
    ip                      = var.faz_ip
    sn                      = var.faz_sn
    source-ip               = var.faz_source_ip_fgt_2
    interface-select-method = var.faz_interface_select_method
  }
}

data "template_file" "config_fmg_fgt_2" {
  template = file("${path.module}/templates/fgt_fmg.conf")
  vars = {
    ip                      = var.fmg_ip
    sn                      = var.fmg_sn
    source-ip               = var.fmg_source_ip_fgt_2
    interface-select-method = var.fmg_interface_select_method
  }
}