##############################################################################################################
# FGT PASSIVE VM
##############################################################################################################

data "template_file" "fgt_passive" {
  template = file("${path.module}/templates/fgt-all.conf")

  vars = {
    fgt_id         = var.config_spoke ? "${var.spoke["id"]}-2" : "${var.hub["id"]}-2"
    admin_port     = var.admin_port
    admin_cidr     = var.admin_cidr
    adminusername  = "admin"
    type           = var.license_type
    license_file   = var.license_file_2
    rsa-public-key = var.rsa-public-key
    api_key        = var.api_key

    public_port  = var.public_port
    public_ip    = var.fgt-passive-ni_ips["public"]
    public_mask  = cidrnetmask(var.subnet_cidrs["public"])
    public_gw    = cidrhost(var.subnet_cidrs["public"], 1)
    private_port = var.private_port
    private_ip   = var.fgt-passive-ni_ips["private"]
    private_mask = cidrnetmask(var.subnet_cidrs["private"])
    private_gw   = cidrhost(var.subnet_cidrs["private"], 1)
    mgmt_port    = var.mgmt_port
    mgmt_ip      = var.fgt-passive-ni_ips["mgmt"]
    mgmt_mask    = cidrnetmask(var.subnet_cidrs["mgmt"])
    mgmt_gw      = cidrhost(var.subnet_cidrs["mgmt"], 1)
    ha_port      = var.ha_port
    ha_ip        = var.fgt-passive-ni_ips["ha"]
    ha_mask      = cidrnetmask(var.subnet_cidrs["ha"])

    fgt_sdn-config        = data.template_file.fgt_sdn-config.rendered
    fgt_ha-fgcp-config    = var.config_fgcp ? data.template_file.fgt_ha-fgcp-passive-config.rendered : ""
    fgt_ha-fgsp-config    = var.config_fgsp ? data.template_file.fgt_ha-fgsp-passive-config.rendered : ""
    fgt_bgp-config        = var.config_spoke ? data.template_file.fgt_spoke_bgp-config.rendered : var.config_hub ? data.template_file.fgt_hub_bgp-config.rendered : ""
    fgt_static-config     = var.vpc-spoke_cidr != null ? data.template_file.fgt_static-config.rendered : ""
    fgt_sdwan-config      = var.config_spoke ? join("\n", data.template_file.fgt_sdwan-config.*.rendered) : ""
    fgt_vpn-config        = var.config_hub ? data.template_file.fgt_vpn-config.1.rendered : ""
    fgt_vxlan-config      = var.config_vxlan ? data.template_file.fgt_vxlan-config.rendered : ""
    fgt_vhub-config       = var.config_vhub ? data.template_file.fgt_vhub-config.rendered : ""
    fgt_ars-config        = var.config_ars ? data.template_file.fgt_ars-config.rendered : ""
    fgt_gwlb-vxlan-config = var.config_gwlb-vxlan ? data.template_file.fgt_gwlb-vxlan-config.rendered : ""
    fgt_fmg-config        = var.config_fmg ? data.template_file.fgt_2_fmg-config.rendered : ""
    fgt_faz-config        = var.config_faz ? data.template_file.fgt_2_faz-config.rendered : ""
    fgt_extra-config      = var.fgt_passive_extra-config
  }
}

data "template_file" "fgt_ha-fgcp-passive-config" {
  template = file("${path.module}/templates/fgt-ha-fgcp.conf")
  vars = {
    fgt_priority = 100
    mgmt_port    = var.mgmt_port
    mgmt_gw      = cidrhost(var.subnet_cidrs["mgmt"], 1)
    ha_port      = var.ha_port
    peerip       = var.fgt-active-ni_ips["ha"]
  }
}

data "template_file" "fgt_ha-fgsp-passive-config" {
  template = file("${path.module}/templates/fgt-ha-fgsp.conf")
  vars = {
    mgmt_port     = var.mgmt_port
    mgmt_gw       = cidrhost(var.subnet_cidrs["mgmt"], 1)
    peerip        = var.fgt-active-ni_ips["mgmt"]
    master_secret = random_string.fgsp_auto-config_secret.result
    master_ip     = var.fgt-active-ni_ips["mgmt"]
  }
}

data "template_file" "fgt_2_faz-config" {
  template = file("${path.module}/templates/fgt-faz.conf")
  vars = {
    ip                      = var.faz_ip
    sn                      = var.faz_sn
    source-ip               = var.faz_fgt-2_source-ip
    interface-select-method = var.faz_interface-select-method
  }
}

data "template_file" "fgt_2_fmg-config" {
  template = file("${path.module}/templates/fgt-fmg.conf")
  vars = {
    ip                      = var.fmg_ip
    sn                      = var.fmg_sn
    source-ip               = var.fmg_fgt-2_source-ip
    interface-select-method = var.fmg_interface-select-method
  }
}