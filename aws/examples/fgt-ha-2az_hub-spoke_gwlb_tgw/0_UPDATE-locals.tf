#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  prefix = "demo-fgt-gwlb"
  region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
  #-----------------------------------------------------------------------------------------------------
  # FGT - ONRAMP
  #-----------------------------------------------------------------------------------------------------
  admin_port = "8443"
  admin_cidr = "${chomp(data.http.my-public-ip.response_body)}/32"

  instance_type = "c6i.large"
  fgt_build     = "build1396"
  license_type  = "payg"

  fgt_vpc_cidr = "172.20.0.0/24"

  hubs = [
    {
      id                = local.hub["id"]
      bgp-asn           = local.hub["bgp-asn_hub"]
      public-ip         = module.fgt_hub.fgt_active_eip_public
      hub-ip            = cidrhost(cidrsubnet(local.hub["vpn_cidr"], 1, 0), 1)
      site-ip           = ""
      hck-srv-ip        = cidrhost(cidrsubnet(local.hub["vpn_cidr"], 1, 0), 1)
      vpn_psk           = module.fgt_hub_config.vpn_psk
      cidr              = local.hub["cidr"]
      ike-version       = local.hub["ike-version"]
      network_id        = local.hub["network_id"]
      dpd-retryinterval = local.hub["dpd-retryinterval"]
    }
  ]
  #-----------------------------------------------------------------------------------------------------
  # FGT - HUB
  #-----------------------------------------------------------------------------------------------------
  fgt_hub_vpc_cidr = "10.0.0.0/24"

  hub = {
    id                = "HUB"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = local.fgt_hub_vpc_cidr
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }
  #-----------------------------------------------------------------------------------------------------
  # VPC spokes
  #-----------------------------------------------------------------------------------------------------
  vpc-spoke_cidrs = ["172.20.100.0/24", "172.20.150.0/24"]
  #-----------------------------------------------------------------------------------------------------
  # TGW
  #-----------------------------------------------------------------------------------------------------
  tgw_bgp-asn     = "65515"
  tgw_cidr        = ["172.20.10.0/24"]
  tgw_inside_cidr = ["169.254.100.0/29", "169.254.101.0/29"]
}
