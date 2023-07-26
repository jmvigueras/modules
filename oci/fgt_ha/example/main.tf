// Create new VNC
module "fgt_vcn" {
  source           = "../../vcn_fgt"
  compartment_ocid = var.compartment_ocid

  region     = var.region
  prefix     = local.prefix
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port

  vcn_cidr = local.vcn_cidr
}
// Create FGT config
module "fgt_config" {
  source = "../../fgt_config"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa_public_key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  fgt_subnet_cidrs = module.fgt_vcn.fgt_subnet_cidrs
  fgt_1_ips        = module.fgt_vcn.fgt_1_ips
  fgt_2_ips        = module.fgt_vcn.fgt_2_ips

  config_fgcp    = true
}
// Create FGT instances
module "fgt" {
  source           = "../"
  compartment_ocid = var.compartment_ocid

  region = var.region
  prefix = local.prefix

  fgt_config_1 = module.fgt_config.fgt_config_1
  fgt_config_2 = module.fgt_config.fgt_config_2

  fgt_vcn_id     = module.fgt_vcn.fgt_vcn_id
  fgt_subnet_ids = module.fgt_vcn.fgt_subnet_ids
  fgt_nsg_ids    = module.fgt_vcn.fgt_nsg_ids
  fgt_1_ips      = module.fgt_vcn.fgt_1_ips
  fgt_2_ips      = module.fgt_vcn.fgt_2_ips
  fgt_1_vnic_ips = module.fgt_vcn.fgt_1_vnic_ips
  fgt_2_vnic_ips = module.fgt_vcn.fgt_2_vnic_ips
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
