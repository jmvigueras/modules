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

  fgt_cluster_type = "fgsp"
  fgt_vpc_cidr     = "172.20.0.0/24"

  hubs = concat(local.hubs_public, local.fgt_hub_cluster_type == "fgsp" ? local.hubs_public_fgsp : [])
  hubs_public = [for hub in local.hub :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.fgt_hub.fgt_active_eip_public
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.fgt_hub_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.fgt_hub_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = module.fgt_hub_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs_public_fgsp = [for hub in local.hub :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.fgt_hub.fgt_passive_eip_public
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      vpn_psk           = module.fgt_hub_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  #-----------------------------------------------------------------------------------------------------
  # FGT - HUB
  #-----------------------------------------------------------------------------------------------------
  fgt_hub_cluster_type = "fgcp"
  fgt_hub_vpc_cidr     = "10.0.0.0/24"

  hub = [{
    id                = "HUB1"
    bgp_asn_hub       = "65000"
    bgp_asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = local.fgt_hub_vpc_cidr
    ike_version       = "2"
    network_id        = "1"
    dpd_retryinterval = "5"
    mode_cfg          = true
    vpn_port          = "public"
  }]

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
