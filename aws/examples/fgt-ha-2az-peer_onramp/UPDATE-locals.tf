#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  count = 1

  prefix        = "demo2"
  admin_port    = "8443"
  admin_cidr    = "${chomp(data.http.my-public-ip.body)}/32"
  instance_type = "c6i.large"
  fgt_build     = "build1396"

  #-----------------------------------------------------------------------------------------------------
  # FGT HUB locals
  #-----------------------------------------------------------------------------------------------------
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

  #-----------------------------------------------------------------------------------------------------
  # FGT onramp
  #-----------------------------------------------------------------------------------------------------
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
      vpn_psk           = local.hub1["vpn_psk"]
      cidr              = local.hub1["cidr"]
      ike-version       = local.hub1["ike-version"]
      network_id        = local.hub1["network_id"]
      dpd-retryinterval = local.hub1["dpd-retryinterval"]
    },
    {
      id                = local.hub1["id"]
      bgp-asn           = local.hub1["bgp-asn_hub"]
      public-ip         = "11.11.11.22"
      hub-ip            = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 1), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub1["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1["vpn_psk"]
      cidr              = local.hub1["cidr"]
      ike-version       = local.hub1["ike-version"]
      network_id        = local.hub1["network_id"]
      dpd-retryinterval = local.hub1["dpd-retryinterval"]
    },
    {
      id                = local.hub2["id"]
      bgp-asn           = local.hub2["bgp-asn_hub"]
      public-ip         = "22.22.22.22"
      hub-ip            = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 0, 0), 1)
      site-ip           = "" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub2["vpn_cidr"], 0, 0), 1)
      vpn_psk           = local.hub2["vpn_psk"]
      cidr              = local.hub2["cidr"]
      ike-version       = local.hub2["ike-version"]
      network_id        = local.hub2["network_id"]
      dpd-retryinterval = local.hub2["dpd-retryinterval"]
    }
  ]
}
