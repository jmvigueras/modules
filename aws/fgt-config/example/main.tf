// Create Active FGT
module "fgt-config_hub-fgsp" {
  source = "../"

  admin_cidr     = local.admin_cidr
  admin_port     = var.admin_port
  keypair        = var.keypair != null ? var.keypair : aws_key_pair.keypair[0].key_name
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = local.subnet_active_cidrs
  subnet_passive_cidrs = local.subnet_passive_cidrs
  fgt-active-ni_ips    = local.fgt-active-ni_ips
  fgt-passive-ni_ips   = local.fgt-passive-ni_ips

  config_hub     = true
  config_fgsp    = true
  hub            = local.hub
  hub-peer_vxlan = local.hub-peer_vxlan
}

module "fgt-config_spoke-fgcp" {
  source = "../"

  admin_cidr     = local.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = local.subnet_active_cidrs
  subnet_passive_cidrs = local.subnet_passive_cidrs
  fgt-active-ni_ips    = local.fgt-active-ni_ips
  fgt-passive-ni_ips   = local.fgt-passive-ni_ips

  config_spoke = true
  config_fgcp  = true
  hubs         = local.hubs
  spoke        = local.spoke
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