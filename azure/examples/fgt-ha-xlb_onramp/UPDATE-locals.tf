locals {
  #-----------------------------------------------------------------------------------------------------
  # FGT HUB locals
  #-----------------------------------------------------------------------------------------------------
  hub1 = {
    id                = "HUB1"
    bgp-asn_hub       = "65000"
    bgp-asn_spoke     = "65000"
    vpn_cidr          = "10.10.10.0/24"
    vpn_psk           = "secret-key-123"
    cidr              = "172.30.100.0/24"
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
    cidr              = "172.30.200.0/24"
    ike-version       = "2"
    network_id        = "1"
    dpd-retryinterval = "5"
    mode-cfg          = true
  }

  admin_cidr = "${chomp(data.http.my-public-ip.body)}/32"

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
  filename        = "./ssh-key/${var.prefix}-ssh-key.pem"
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
  count       = var.storage-account_endpoint == null ? 1 : 0
  byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
  count                    = var.storage-account_endpoint == null ? 1 : 0
  name                     = "stgra${random_id.randomId[count.index].hex}"
  resource_group_name      = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}