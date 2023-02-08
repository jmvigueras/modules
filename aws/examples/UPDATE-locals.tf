#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  count = 2

  hub1 = {
    id                = "HUB1"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "192.168.1.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
  hub2 = {
    id                = "HUB2"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.20.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "192.168.2.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }

  hub1-peer_vxlan = {
    bgp-asn   = "65000"
    public-ip = ""
    remote-ip = "10.10.30.2"
    local-ip  = "10.10.30.1"
    vni       = "1100"
  }

  hub2-peer_vxlan = {
    bgp-asn   = "65000"
    public-ip = ""
    remote-ip = "10.10.30.1"
    local-ip  = "10.10.30.2"
    vni       = "1100"
  }

  admin_cidr    = "${chomp(data.http.my-public-ip.body)}/32"
  instance_type = "c5.large"
  fgt_build     = "build1396"

  onramp = {
    id      = "onramp"
    cidr    = "172.30.0.0/24"
    bgp-asn = local.hub1["bgp-asn_spoke"]
  }

  vpc-spoke_cidr = "172.30.100.0/23"

  tgw_bgp-asn     = "65515"
  tgw_cidr        = ["172.30.10.0/24"]
  tgw_inside_cidr = ["169.254.100.0/29", "169.254.101.0/29"]

  spoke = {
    id      = "spoke"
    cidr    = "192.168.10.0/23"
    bgp-asn = local.hub1["bgp-asn_spoke"]
  }

  hubs = [
    {
      id                = local.hub1["id"]
      bgp-asn           = local.hub1["bgp-asn_hub"]
      public-ip         = "11.11.11.11"
      hub-ip            = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 0), 1)
      vpn_psk           = "secret-key"
      cidr              = local.hub1["cidr"]
      ike-version       = local.hub1["ike-version"]
      network_id        = local.hub1["network_id"]
      dpd-retryinterval = local.hub1["dpd-retryinterval"]
    }
    /*
    {
      id                = local.hub1["id"]
      bgp-asn           = local.hub1["bgp-asn_hub"]
      public-ip         = module.fgt_hub1.fgt_active_eip_public
      hub-ip            = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 0), 1)
      vpn_psk           = module.fgt_hub1_config.vpn_psk
      cidr              = local.hub1["cidr"]
      ike-version       = local.hub1["ike-version"]
      network_id        = local.hub1["network_id"]
      dpd-retryinterval = local.hub1["dpd-retryinterval"]
    },
    {
      id                = local.hub1["id"]
      bgp-asn           = local.hub1["bgp-asn_hub"]
      public-ip         = module.fgt_hub1.fgt_passive_eip_public[0]
      hub-ip            = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 1), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 1), 1)
      vpn_psk           = module.fgt_hub1_config.vpn_psk
      cidr              = local.hub1["cidr"]
      ike-version       = local.hub1["ike-version"]
      network_id        = local.hub1["network_id"]
      dpd-retryinterval = local.hub1["dpd-retryinterval"]
    },
    {
      id                = local.hub2["id"]
      bgp-asn           = local.hub2["bgp-asn_hub"]
      public-ip         = module.fgt_hub2.fgt_active_eip_public
      hub-ip            = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 0, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 0, 0), 1)
      vpn_psk           = module.fgt_hub2_config.vpn_psk
      cidr              = local.hub2["cidr"]
      ike-version       = local.hub2["ike-version"]
      network_id        = local.hub2["network_id"]
      dpd-retryinterval = local.hub2["dpd-retryinterval"]
    },
    {
      id                = local.hub2["id"]
      bgp-asn           = local.hub2["bgp-asn_hub"]
      public-ip         = module.fgt_hub2.fgt_active_eip_public
      hub-ip            = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 1, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 1, 0), 1)
      vpn_psk           = module.fgt_hub2_config.vpn_psk
      cidr              = local.hub2["cidr"]
      ike-version       = local.hub2["ike-version"]
      network_id        = local.hub2["network_id"]
      dpd-retryinterval = local.hub2["dpd-retryinterval"]
    },
    {
      id                = local.hub2["id"]
      bgp-asn           = local.hub2["bgp-asn_hub"]
      public-ip         = module.fgt_hub2.fgt_passive_eip_public[0]
      hub-ip            = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 1, 1), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 1, 1), 1)
      vpn_psk           = module.fgt_hub2_config.vpn_psk
      cidr              = local.hub2["cidr"]
      ike-version       = local.hub2["ike-version"]
      network_id        = local.hub2["network_id"]
      dpd-retryinterval = local.hub2["dpd-retryinterval"]
    }
    */
  ]
}
