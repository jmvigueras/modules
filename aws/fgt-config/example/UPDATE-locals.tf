#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  hub = {
    id                = "HUB-AWS"
    bgp-asn_hub       = "65002"
    bgp-asn_spoke     = "65011"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "192.168.0.0/24"
    ike-version       = "2"
    networkd_id       = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }

  hub-peer_vxlan = {
    bgp-asn   = "65002"
    public-ip = ""
    remote-ip = "10.10.30.1"
    local-ip  = "10.10.30.2"
    vni       = "1100"
  }

  admin_cidr = "${chomp(data.http.my-public-ip.body)}/32"

  spoke = {
    id      = "spoke-1"
    cidr    = "192.168.0.0/24"
    bgp-asn = "65011"
  }

  hubs = [
    {
      id                = "HUB1"
      bgp-asn           = "65001"
      public-ip         = "11.11.11.11"
      hub-ip            = "172.20.30.1"
      site-ip           = "172.20.30.10" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = "172.20.30.1"
      vpn_psk           = "secret"
      cidr              = "172.20.30.0/24"
      ike-version       = "2"
      networkd_id       = "1"
      dpd-retryinterval = "5"
    },
    {
      id                = "HUB2"
      bgp-asn           = "65003"
      public-ip         = "22.22.22.2"
      hub-ip            = "172.20.40.1"
      site-ip           = "172.20.40.10" // set to "" if VPN mode-cfg is enable
      hck-srv-ip        = "172.20.40.1"
      vpn_psk           = "secret"
      cidr              = "172.20.40.0/24"
      ike-version       = "2"
      networkd_id       = "1"
      dpd-retryinterval = "5"
    }
  ]
}

locals {
  subnet_active_cidrs = {
    mgmt    = cidrsubnet(local.hub["cidr"], 4, 0)
    public  = cidrsubnet(local.hub["cidr"], 4, 1)
    private = cidrsubnet(local.hub["cidr"], 4, 2)
  }
  subnet_passive_cidrs = {
    mgmt    = cidrsubnet(local.hub["cidr"], 4, 8)
    public  = cidrsubnet(local.hub["cidr"], 4, 9)
    private = cidrsubnet(local.hub["cidr"], 4, 10)
  }
  fgt-active-ni_ips = {
    mgmt    = cidrhost(local.subnet_active_cidrs["mgmt"], 10)
    public  = cidrhost(local.subnet_active_cidrs["public"], 10)
    private = cidrhost(local.subnet_active_cidrs["private"], 10)
  }
  fgt-passive-ni_ips = {
    mgmt    = cidrhost(local.subnet_passive_cidrs["mgmt"], 10)
    public  = cidrhost(local.subnet_passive_cidrs["public"], 10)
    private = cidrhost(local.subnet_passive_cidrs["private"], 10)
  }
}