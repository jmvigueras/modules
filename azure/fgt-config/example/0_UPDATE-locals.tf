locals {
  admin_cidr = "0.0.0.0/0"
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB VPN locals
  #-----------------------------------------------------------------------------------------------------
  hub1_cluster_type = "fgsp"
  hub2_cluster_type = "fgsp"

  hub1 = [
    {
      id                = "HUB1"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.1.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.20.0.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
    },
    {
      id                = "HUB1"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.10.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.20.0.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "private"
    }
  ]
  hub2 = [
    {
      id                = "HUB2"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.2.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
    },
    {
      id                = "HUB2"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.20.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.0.0/24"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "private"
    }
  ]
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB vxlan locals
  #-----------------------------------------------------------------------------------------------------
  hub1_peer_vxlan = [
    {
      bgp_asn     = local.hub2[0]["bgp_asn_hub"]
      external_ip = "20.216.155.67"
      remote_ip   = "10.0.3.2"
      local_ip    = "10.0.3.1"
      vni         = "1100"
      vxlan_port  = "public"
    },
    {
      bgp_asn     = local.hub2[1]["bgp_asn_hub"]
      external_ip = "172.30.0.106"
      remote_ip   = "10.0.30.2"
      local_ip    = "10.0.30.1"
      vni         = "1100"
      vxlan_port  = "private"
    }
  ]
  hub2_peer_vxlan = [
    {
      bgp_asn     = local.hub1[0]["bgp_asn_hub"]
      external_ip = "20.216.155.67"
      remote_ip   = "10.0.3.2"
      local_ip    = "10.0.3.1"
      vni         = "1100"
      vxlan_port  = "public"
    },
    {
      bgp_asn     = local.hub1[1]["bgp_asn_hub"]
      external_ip = "172.30.0.106"
      remote_ip   = "10.0.30.2"
      local_ip    = "10.0.30.1"
      vni         = "1100"
      vxlan_port  = "private"
    }
  ]
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB vxlan locals
  #-----------------------------------------------------------------------------------------------------
  vhub_peer = ["172.30.110.68", "172.30.110.69"]
  rs_peer = [
    ["172.30.100.132", "172.30.100.133"]
  ]
  gwlb_vxlan = {
    vdi_ext  = "800"
    vdi_int  = "801"
    port_ext = "10800"
    port_int = "10801"
    ip       = "172.30.100.15"
  }
  #-----------------------------------------------------------------------------------------------------
  # FGT Spoke locals
  #-----------------------------------------------------------------------------------------------------
  spoke_cluster_type = "fgcp"
  spoke = {
    id      = "spoke-1"
    cidr    = "172.30.0.0/24"
    bgp_asn = "65000"
  }

  hubs = concat(local.hubs_hub1_fgcp, local.hub1_cluster_type == "fgsp" ? local.hubs_hub1_fgsp : [], local.hubs_hub2_fgcp, local.hub2_cluster_type == "fgsp" ? local.hubs_hub2_fgsp : [])

  hubs_hub1_fgcp = [for hub in local.hub1 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = hub["vpn_port"] == "public" ? "11.11.11.11" : "172.20.0.205"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = hub["mode_cfg"] ? "" : cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 2)
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs_hub1_fgsp = [for hub in local.hub1 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = hub["vpn_port"] == "public" ? "11.11.11.11" : "172.20.0.205"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = hub["mode_cfg"] ? "" : cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 2)
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]

  hubs_hub2_fgcp = [for hub in local.hub2 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = hub["vpn_port"] == "public" ? "11.11.22.22" : "172.30.0.205"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = hub["mode_cfg"] ? "" : cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 2)
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs_hub2_fgsp = [for hub in local.hub2 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = hub["vpn_port"] == "public" ? "11.11.22.22" : "172.30.0.205"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = hub["mode_cfg"] ? "" : cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 2)
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
}

// Following variables are using instead of outputs from other modules
locals {
  subnet_cidrs = {
    mgmt    = cidrsubnet(local.hub1[0]["cidr"], 4, 0)
    public  = cidrsubnet(local.hub1[0]["cidr"], 4, 1)
    private = cidrsubnet(local.hub1[0]["cidr"], 4, 2)
    vgw     = cidrsubnet(local.hub1[0]["cidr"], 4, 3)
    rs      = cidrsubnet(local.hub1[0]["cidr"], 4, 4)
  }
  fgt-active-ni_ips = {
    mgmt    = cidrhost(local.subnet_cidrs["mgmt"], 10)
    public  = cidrhost(local.subnet_cidrs["public"], 10)
    private = cidrhost(local.subnet_cidrs["private"], 10)
  }
  fgt-passive-ni_ips = {
    mgmt    = cidrhost(local.subnet_cidrs["mgmt"], 11)
    public  = cidrhost(local.subnet_cidrs["public"], 11)
    private = cidrhost(local.subnet_cidrs["private"], 11)
  }
}