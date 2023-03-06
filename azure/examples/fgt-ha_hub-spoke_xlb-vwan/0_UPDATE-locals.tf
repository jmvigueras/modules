locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  resource_group_name      = null // a new resource group will be created if null
  location                 = "francecentral"
  storage-account_endpoint = null               // a new resource group will be created if null
  prefix                   = "demo-fgt-ha-vwan" // prefix added to all resources created

  admin_port     = "8443"
  admin_cidr     = "${chomp(data.http.my-public-ip.body)}/32"
  admin_username = "azureadmin"
  admin_password = "Terraform123#"

  license_type = "payg"
  fgt_size     = "Standard_F4"
  fgt_version  = "latest"

  tags = {
    Deploy  = "module-fgt-ha-xlb"
    Project = "terraform-fortinet"
  }
  #-----------------------------------------------------------------------------------------------------
  # LB locals
  #-----------------------------------------------------------------------------------------------------
  config_gwlb        = true
  ilb_ip             = cidrhost(module.fgt_spoke_vnet.subnet_cidrs["private"], 9)
  backend-probe_port = "8008"

  gwlb_ip = cidrhost(module.fgt_spoke_vnet.subnet_cidrs["private"], 8)
  gwlb_vxlan = {
    vdi_ext  = "800"
    vdi_int  = "801"
    port_ext = "10800"
    port_int = "10801"
  }

  #-----------------------------------------------------------------------------------------------------
  # vWAN
  #-----------------------------------------------------------------------------------------------------
  vhub_cidr             = "172.30.14.0/23"
  vhub_vnet-spoke_cidrs = ["172.30.18.0/23"]

  #-----------------------------------------------------------------------------------------------------
  # FGT HUB locals
  #-----------------------------------------------------------------------------------------------------
  hub1 = [
    {
      id                = "HUB1"
      bgp_asn_hub       = "65000"
      bgp_asn_spoke     = "65000"
      vpn_cidr          = "10.0.1.0/24"
      vpn_psk           = "secret-key-123"
      cidr              = "172.20.0.0/23"
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
      cidr              = "172.30.0.0/23"
      ike_version       = "2"
      network_id        = "1"
      dpd_retryinterval = "5"
      mode_cfg          = true
      vpn_port          = "public"
    }
  ]
  hub1_peer_vxlan = [
    {
      bgp_asn     = local.hub2[0]["bgp_asn_hub"]
      external_ip = ""
      remote_ip   = "10.10.30.2"
      local_ip    = "10.10.30.1"
      vni         = "1100"
      vxlan_port  = "public"
    }
  ]
  hub2_peer_vxlan = [
    {
      bgp_asn     = local.hub1[0]["bgp_asn_hub"]
      external_ip = ""
      remote_ip   = "10.10.30.1"
      local_ip    = "10.10.30.2"
      vni         = "1100"
      vxlan_port  = "public"
    }
  ]

  fgt_vnet-spoke_cidrs = ["172.30.16.0/23"]

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
      external_ip       = module.fgt_hub_vnet.fgt-active-public-ip
      hub_ip            = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 0), 1)
      site_ip           = "" // set to "" if VPN mode-cfg is enable
      hck_ip            = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 0), 1)
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
      external_ip       = module.fgt_hub_vnet.fgt-passive-public-ip
      hub_ip            = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 1), 1)
      site_ip           = "" // set to "" if VPN mode-cfg is enable
      hck_ip            = cidrhost(cidrsubnet(local.hub1[0]["vpn_cidr"], 1, 1), 1)
      vpn_psk           = local.hub1[0]["vpn_psk"]
      cidr              = local.hub1[0]["cidr"]
      ike_version       = local.hub1[0]["ike_version"]
      network_id        = local.hub1[0]["network_id"]
      dpd_retryinterval = local.hub1[0]["dpd_retryinterval"]
      sdwan_port        = "public"
    },
    {
      id                = local.hub2[0]["id"]
      bgp_asn           = local.hub2[0]["bgp_asn_hub"]
      external_ip       = "22.22.22.22"
      hub_ip            = cidrhost(cidrsubnet(local.hub2[0]["vpn_cidr"], 0, 0), 1)
      site_ip           = "" // set to "" if VPN mode-cfg is enable
      hck_ip            = cidrhost(cidrsubnet(local.hub2[0]["vpn_cidr"], 0, 0), 1)
      vpn_psk           = local.hub2[0]["vpn_psk"]
      cidr              = local.hub2[0]["cidr"]
      ike_version       = local.hub2[0]["ike_version"]
      network_id        = local.hub2[0]["network_id"]
      dpd_retryinterval = local.hub2[0]["dpd_retryinterval"]
      sdwan_port        = "public"
    }
  ]
}

#-----------------------------------------------------------------------
# Necessary variables

data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${local.prefix}-ssh-key.pem"
  file_permission = "0600"
}

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "vpn_psk" {
  length  = 30
  special = false
  numeric = true
}

// Create storage account if not provided
resource "random_id" "randomId" {
  count       = local.storage-account_endpoint == null ? 1 : 0
  byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
  count                    = local.storage-account_endpoint == null ? 1 : 0
  name                     = "stgra${random_id.randomId[count.index].hex}"
  resource_group_name      = local.resource_group_name == null ? azurerm_resource_group.rg[0].name : local.resource_group_name
  location                 = local.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = local.tags
}

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = local.resource_group_name == null ? 1 : 0
  name     = "${local.prefix}-rg"
  location = local.location

  tags = local.tags
}