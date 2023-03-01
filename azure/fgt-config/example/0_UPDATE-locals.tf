locals {
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB locals
  #-----------------------------------------------------------------------------------------------------
  hub1_public = {
    id                = "HUB1"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.20.0.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
  hub1_private = {
    id                = "HUB1"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.100.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.20.0.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
  hub2_public = {
    id                = "HUB2"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.20.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.30.0.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
  hub2_private = {
    id                = "HUB2"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.200.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.30.0.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
  hub1_peer_vxlan_public = {
    bgp-asn     = local.hub2_public["bgp-asn_hub"]
    external-ip = "20.216.155.67"
    remote-ip   = "10.10.3.2"
    local-ip    = "10.10.3.1"
    vni         = "1100"
  }
  hub2_peer_vxlan_public = {
    bgp-asn     = local.hub1_public["bgp-asn_hub"]
    external-ip = "20.160.201.210"
    remote-ip   = "10.10.3.1"
    local-ip    = "10.10.3.2"
    vni         = "1100"
  }
  hub1_peer_vxlan_private = {
    bgp-asn     = local.hub2_public["bgp-asn_hub"]
    external-ip = "172.30.0.106"
    remote-ip   = "10.10.30.2"
    local-ip    = "10.10.30.1"
    vni         = "1100"
  }
  hub2_peer_vxlan_private = {
    bgp-asn     = local.hub1_public["bgp-asn_hub"]
    external-ip = "172.20.0.106"
    remote-ip   = "10.10.30.1"
    local-ip    = "10.10.30.2"
    vni         = "1100"
  }
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

  admin_cidr = "${chomp(data.http.my-public-ip.body)}/32"

  hubs_hub = [
    {
      id                = local.hub1_private["id"]
      bgp-asn           = local.hub1_private["bgp-asn_hub"]
      public-ip         = "172.20.0.46"
      hub-ip            = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 0), 1)
      vpn_psk           = local.hub1_private["vpn_psk"]
      cidr              = local.hub1_private["cidr"]
      ike-version       = local.hub1_private["ike-version"]
      network_id        = local.hub1_private["network_id"]
      dpd-retryinterval = local.hub1_private["dpd-retryinterval"]
    },
    {
      id                = local.hub1_private["id"]
      bgp-asn           = local.hub1_private["bgp-asn_hub"]
      public-ip         = "172.20.0.97"
      hub-ip            = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 1), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1_private["vpn_psk"]
      cidr              = local.hub1_private["cidr"]
      ike-version       = local.hub1_private["ike-version"]
      network_id        = local.hub1_private["network_id"]
      dpd-retryinterval = local.hub1_private["dpd-retryinterval"]
    }
  ]
  #-----------------------------------------------------------------------------------------------------
  # FGT Spoke locals
  #-----------------------------------------------------------------------------------------------------
  spoke = {
    id      = "spoke-1"
    cidr    = "172.30.0.0/24"
    bgp-asn = "65000"
  }
  hubs = [
    {
      id                = local.hub1_public["id"]
      bgp-asn           = local.hub1_public["bgp-asn_hub"]
      public-ip         = "11.11.11.11"
      hub-ip            = cidrhost(cidrsubnet(local.hub1_public["vpn_cidr"], 1, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1_public["vpn_cidr"], 1, 0), 1)
      vpn_psk           = local.hub1_public["vpn_psk"]
      cidr              = local.hub1_public["cidr"]
      ike-version       = local.hub1_public["ike-version"]
      network_id        = local.hub1_public["network_id"]
      dpd-retryinterval = local.hub1_public["dpd-retryinterval"]
    },
    {
      id                = local.hub1_public["id"]
      bgp-asn           = local.hub1_public["bgp-asn_hub"]
      public-ip         = "11.11.22.22"
      hub-ip            = cidrhost(cidrsubnet(local.hub1_public["vpn_cidr"], 1, 1), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1_public["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1_public["vpn_psk"]
      cidr              = local.hub1_public["cidr"]
      ike-version       = local.hub1_public["ike-version"]
      network_id        = local.hub1_public["network_id"]
      dpd-retryinterval = local.hub1_public["dpd-retryinterval"]
    },
    {
      id                = local.hub1_private["id"]
      bgp-asn           = local.hub1_private["bgp-asn_hub"]
      public-ip         = "172.20.0.46"
      hub-ip            = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 0), 1)
      vpn_psk           = local.hub1_private["vpn_psk"]
      cidr              = local.hub1_private["cidr"]
      ike-version       = local.hub1_private["ike-version"]
      network_id        = local.hub1_private["network_id"]
      dpd-retryinterval = local.hub1_private["dpd-retryinterval"]
    },
    {
      id                = local.hub1_private["id"]
      bgp-asn           = local.hub1_private["bgp-asn_hub"]
      public-ip         = "172.20.0.97"
      hub-ip            = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 1), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1_private["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1_private["vpn_psk"]
      cidr              = local.hub1_private["cidr"]
      ike-version       = local.hub1_private["ike-version"]
      network_id        = local.hub1_private["network_id"]
      dpd-retryinterval = local.hub1_private["dpd-retryinterval"]
    },
    {
      id                = local.hub2_public["id"]
      bgp-asn           = local.hub2_public["bgp-asn_hub"]
      public-ip         = "22.22.22.22"
      hub-ip            = cidrhost(cidrsubnet(local.hub2_public["vpn_cidr"], 0, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub2_public["vpn_cidr"], 0, 0), 1)
      vpn_psk           = local.hub2_public["vpn_psk"]
      cidr              = local.hub2_public["cidr"]
      ike-version       = local.hub2_public["ike-version"]
      network_id        = local.hub2_public["network_id"]
      dpd-retryinterval = local.hub2_public["dpd-retryinterval"]
    },
    {
      id                = local.hub2_private["id"]
      bgp-asn           = local.hub2_private["bgp-asn_hub"]
      public-ip         = "172.30.0.96"
      hub-ip            = cidrhost(cidrsubnet(local.hub2_private["vpn_cidr"], 0, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub2_private["vpn_cidr"], 0, 0), 1)
      vpn_psk           = local.hub2_private["vpn_psk"]
      cidr              = local.hub2_private["cidr"]
      ike-version       = local.hub2_private["ike-version"]
      network_id        = local.hub2_private["network_id"]
      dpd-retryinterval = local.hub2_private["dpd-retryinterval"]
    }
  ]
}



locals {
  subnet_cidrs = {
    mgmt    = cidrsubnet(local.hub1_public["cidr"], 4, 0)
    public  = cidrsubnet(local.hub1_public["cidr"], 4, 1)
    private = cidrsubnet(local.hub1_public["cidr"], 4, 2)
    vgw     = cidrsubnet(local.hub1_public["cidr"], 4, 3)
    rs      = cidrsubnet(local.hub1_public["cidr"], 4, 4)
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