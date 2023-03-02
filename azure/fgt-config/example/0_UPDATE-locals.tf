locals {
  admin_cidr = "0.0.0.0/0"
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB VPN locals
  #-----------------------------------------------------------------------------------------------------
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
  spoke = {
    id      = "spoke-1"
    cidr    = "172.30.0.0/24"
    bgp_asn = "65000"
  }
  hubs = [
    {
      id                = local.hub1[0]["id"]
      bgp_asn           = local.hub1[0]["bgp_asn_hub"]
      external_ip         = "11.11.11.11"
      hub_ip            = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 0), 1)
      site_ip           = "" // set to "" if VPN mode_cfg is enable
      hck_ip        = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 0), 1)
      vpn_psk           = local.hub1[0]["vpn_psk"]
      cidr              = local.hub1[0]["cidr"]
      ike_version       = local.hub1[0]["ike_version"]
      network_id        = local.hub1[0]["network_id"]
      dpd_retryinterval = local.hub1[0]["dpd_retryinterval"]
      sdwan_port        = "public"
    },
    {
      id                = local.hub1[0]["id"]
      bgp_asn           = local.hub1[0]["bgp_asn_hub"]
      external_ip         = "11.11.22.22"
      hub_ip            = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 1), 1)
      site_ip           = "" // set to "" if VPN mode_cfg is enable
      hck_ip        = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1[0]["vpn_psk"]
      cidr              = local.hub1[0]["cidr"]
      ike_version       = local.hub1[0]["ike_version"]
      network_id        = local.hub1[0]["network_id"]
      dpd_retryinterval = local.hub1[0]["dpd_retryinterval"]
      sdwan_port        = "public"
    },
    {
      id                = local.hub1[1]["id"]
      bgp_asn           = local.hub1[1]["bgp_asn_hub"]
      external_ip         = "172.20.0.46"
      hub_ip            = cidrhost(cidrsubnet(local.hub1[1]["vpn_cidr"], 1, 0), 1)
      site_ip           = "" // set to "" if VPN mode_cfg is enable
      hck_ip        = cidrhost(cidrsubnet(local.hub1[1]["vpn_cidr"], 1, 0), 1)
      vpn_psk           = local.hub1[1]["vpn_psk"]
      cidr              = local.hub1[1]["cidr"]
      ike_version       = local.hub1[1]["ike_version"]
      network_id        = local.hub1[1]["network_id"]
      dpd_retryinterval = local.hub1[1]["dpd_retryinterval"]
      sdwan_port        = "private"
    },
    {
      id                = local.hub1[1]["id"]
      bgp_asn           = local.hub1[1]["bgp_asn_hub"]
      external_ip         = "172.20.0.97"
      hub_ip            = cidrhost(cidrsubnet(local.hub1[1]["vpn_cidr"], 1, 1), 1)
      site_ip           = "" // set to "" if VPN mode_cfg is enable
      hck_ip        = cidrhost(cidrsubnet(local.hub1[1]["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1[1]["vpn_psk"]
      cidr              = local.hub1[1]["cidr"]
      ike_version       = local.hub1[1]["ike_version"]
      network_id        = local.hub1[1]["network_id"]
      dpd_retryinterval = local.hub1[1]["dpd_retryinterval"]
      sdwan_port        = "private"
    },
    {
      id                = local.hub2[0]["id"]
      bgp_asn           = local.hub2[0]["bgp_asn_hub"]
      external_ip         = "22.22.22.22"
      hub_ip            = cidrhost(cidrsubnet(local.hub2[0]["vpn_cidr"], 0, 0), 1)
      site_ip           = "" // set to "" if VPN mode_cfg is enable
      hck_ip        = cidrhost(cidrsubnet(local.hub2[0]["vpn_cidr"], 0, 0), 1)
      vpn_psk           = local.hub2[0]["vpn_psk"]
      cidr              = local.hub2[0]["cidr"]
      ike_version       = local.hub2[0]["ike_version"]
      network_id        = local.hub2[0]["network_id"]
      dpd_retryinterval = local.hub2[0]["dpd_retryinterval"]
      sdwan_port        = "public"
    },
    {
      id                = local.hub2[1]["id"]
      bgp_asn           = local.hub2[1]["bgp_asn_hub"]
      external_ip         = "172.30.0.96"
      hub_ip            = cidrhost(cidrsubnet(local.hub2[1]["vpn_cidr"], 0, 0), 1)
      site_ip           = "" // set to "" if VPN mode_cfg is enable
      hck_ip        = cidrhost(cidrsubnet(local.hub2[1]["vpn_cidr"], 0, 0), 1)
      vpn_psk           = local.hub2[1]["vpn_psk"]
      cidr              = local.hub2[1]["cidr"]
      ike_version       = local.hub2[1]["ike_version"]
      network_id        = local.hub2[1]["network_id"]
      dpd_retryinterval = local.hub2[1]["dpd_retryinterval"]
      sdwan_port        = "private"
    }
  ]
}



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