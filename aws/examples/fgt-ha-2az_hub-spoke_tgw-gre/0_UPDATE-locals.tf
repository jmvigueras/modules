#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  count = 2 // number of VPC spokes attached to TGW and number of FGT spoke in SDWAN
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  prefix = "demo-fgt-sdwan"
  region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
  #-----------------------------------------------------------------------------------------------------
  # FGT locals
  #-----------------------------------------------------------------------------------------------------
  admin_port = "8443"
  admin_cidr = "${chomp(data.http.my-public-ip.response_body)}/32"

  instance_type = "c6i.large"
  fgt_build     = "build1396"
  license_type  = "payg"
  #-----------------------------------------------------------------------------------------------------
  # HUB locals
  #-----------------------------------------------------------------------------------------------------
  hub1 = [{
    id                = "HUB1"
    bgp_asn_hub       = "65000"
    bgp_asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = local.hub1_spoke_vpc_cidr
    ike_version       = "2"
    network_id        = "1"
    dpd_retryinterval = "5"
    mode_cfg          = true
    vpn_port          = "public"
  }]
  hub2 = [{
    id                = "HUB2"
    bgp_asn_hub       = "65000"
    bgp_asn_spoke     = "65000"
    vpn_cidr          = "10.10.20.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = local.hub2_spoke_vpc_cidr
    ike_version       = "2"
    network_id        = "1"
    dpd_retryinterval = "5"
    mode_cfg          = true
    vpn_port          = "public"
  }]

  hub1_cluster_type   = "fgsp"
  hub1_fgt_vpc_cidr   = "172.20.0.0/23"
  hub1_spoke_vpc_cidr = "172.20.100.0/23"

  hub2_cluster_type   = "fgcp"
  hub2_fgt_vpc_cidr   = "172.30.0.0/23"
  hub2_spoke_vpc_cidr = "172.30.100.0/23"

  tgw_bgp-asn     = "65515"
  tgw_cidr        = ["172.20.10.0/24"]
  tgw_inside_cidr = ["169.254.100.0/29", "169.254.101.0/29"]

  #-----------------------------------------------------------------------------------------------------
  # FGT SDWAN Spoke locals
  #-----------------------------------------------------------------------------------------------------
  fgt_spoke_count = 2

  spoke = {
    id      = "spoke"
    cidr    = "192.168.10.0/23"
    bgp-asn = local.hub1[0]["bgp_asn_spoke"]
  }

  hubs  = concat(local.hubs1, local.hubs2)
  hubs1 = concat(local.hubs1_public, local.hub1_cluster_type == "fgsp" ? local.hubs1_public_fgsp : [])
  hubs2 = concat(local.hubs2_public, local.hub2_cluster_type == "fgsp" ? local.hubs2_public_fgsp : [])
  hubs1_public = [for hub in local.hub1 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.fgt_hub1.fgt_active_eip_public
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = module.fgt_hub1_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs1_public_fgsp = [for hub in local.hub1 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.fgt_hub1.fgt_passive_eip_public
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      vpn_psk           = module.fgt_hub1_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs2_public = [for hub in local.hub2 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.fgt_hub2.fgt_active_eip_public
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = module.fgt_hub2_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs2_public_fgsp = [for hub in local.hub2 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = module.fgt_hub2.fgt_passive_eip_public
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      vpn_psk           = module.fgt_hub2_config.vpn_psk
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
}
