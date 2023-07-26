#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB locals
  #-----------------------------------------------------------------------------------------------------
  hub1_cluster_type = "fgsp"
  hub2_cluster_type = "fgcp"

  hub1 = [
    {
      id                = "HUB1"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.1.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.30.100.0/23"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
    }
  ]
  hub2 = [
    {
      id                = "HUB2"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.2.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.20.100.0/23"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
    }
  ]
  hub1_peer_vxlan = {
    bgp-asn   = local.hub2[0]["bgp_asn_hub"]
    public-ip = "11.11.11.11"
    remote-ip = "10.10.30.2"
    local-ip  = "10.10.30.1"
    vni       = "1100"
  }
  hub2_peer_vxlan = {
    bgp-asn   = local.hub1[0]["bgp_asn_hub"]
    public-ip = "22.22.22.22"
    remote-ip = "10.10.30.1"
    local-ip  = "10.10.30.2"
    vni       = "1100"
  }

  admin_cidr = "${chomp(data.http.my-public-ip.response_body)}/32"

  #-----------------------------------------------------------------------------------------------------
  # FGT Spoke locals
  #-----------------------------------------------------------------------------------------------------
  spoke = {
    id      = "spoke-1"
    cidr    = "172.30.0.0/24"
    bgp_asn = "65000"
  }

  hubs      = concat(local.hubs_hub1, local.hubs_hub2)
  hubs_hub1 = concat(local.hubs_hub1_public, local.hub1_cluster_type == "fgsp" ? local.hubs_hub1_public_fgsp : [])
  hubs_hub2 = concat(local.hubs_hub2_public, local.hub2_cluster_type == "fgsp" ? local.hubs_hub2_public_fgsp : [])

  hubs_hub1_public = [for hub in local.hub1 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = "11.11.11.11"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub1_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs_hub1_public_fgsp = [for hub in local.hub1 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = "11.11.11.22"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs_hub2_public = [for hub in local.hub2 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = "22.22.22.11"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      site_ip           = ""
      hck_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], local.hub2_cluster_type == "fgsp" ? 1 : 0, 0), 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  hubs_hub2_public_fgsp = [for hub in local.hub2 :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = "22.22.22.22"
      hub_ip            = cidrhost(cidrsubnet(hub["vpn_cidr"], 1, 1), 1)
      site_ip           = ""
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

#-----------------------------------------------------------------------------------------------------
# FGT active-passive necessary variables 
#-----------------------------------------------------------------------------------------------------
locals {
  fgt_subnet_cidrs = {
    mgmt    = cidrsubnet(local.hub1[0]["cidr"], 4, 0)
    public  = cidrsubnet(local.hub1[0]["cidr"], 4, 1)
    private = cidrsubnet(local.hub1[0]["cidr"], 4, 2)
  }
  fgt_1_ips = {
    mgmt    = cidrhost(local.fgt_subnet_cidrs["mgmt"], 10)
    public  = cidrhost(local.fgt_subnet_cidrs["public"], 10)
    private = cidrhost(local.fgt_subnet_cidrs["private"], 10)
  }
  fgt_2_ips = {
    mgmt    = cidrhost(local.fgt_subnet_cidrs["mgmt"], 10)
    public  = cidrhost(local.fgt_subnet_cidrs["public"], 10)
    private = cidrhost(local.fgt_subnet_cidrs["private"], 10)
  }
}