// Create new Fortigate VNC
module "fgt_vcn" {
  source           = "../../vcn_fgt"
  compartment_ocid = var.compartment_ocid

  region     = var.region
  prefix     = local.prefix
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port

  vcn_cidr = local.fgt_vcn_cidr
}
// Create FGT config
module "fgt_config" {
  source           = "../../fgt_config"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa_public_key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  license_type   = local.license_type
  license_file_1 = local.license_file_1
  license_file_2 = local.license_file_2

  fgt_subnet_cidrs = module.fgt_vcn.fgt_subnet_cidrs
  fgt_1_ips        = module.fgt_vcn.fgt_1_ips
  fgt_2_ips        = module.fgt_vcn.fgt_2_ips

  config_fgcp = true

  vcn_spoke_cidrs = [local.spoke_vcn_cidr, module.fgt_vcn.fgt_subnet_cidrs["bastion"]]
}
// Create FGT instances
module "fgt" {
  source           = "../../fgt_ha"
  compartment_ocid = var.compartment_ocid

  region = var.region
  prefix = local.prefix

  license_type = local.license_type
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
// Create new DRG
module "drg" {
  depends_on = [module.fgt_vcn, module.fgt]
  source     = "../../drg"

  compartment_ocid = var.compartment_ocid
  prefix           = local.prefix

  fgt_vcn_id        = module.fgt_vcn.fgt_vcn_id
  fgt_vcn_rt_drg_id = module.fgt.fgt_vcn_rt_to_fgt_id
  fgt_subnet_ids    = module.fgt_vcn.fgt_subnet_ids
}
// Create spoke VCN and attached to DRG
module "spoke_vcn" {
  source = "../../vcn_spoke_drg"

  compartment_ocid = var.compartment_ocid
  prefix           = local.prefix

  admin_cidr = local.admin_cidr
  vcn_cidr   = local.spoke_vcn_cidr
  drg_id     = module.drg.drg_id
  drg_rt_id  = module.drg.drg_rt_ids["pre"]
}
// Create new test instance
module "spoke_vm" {
  source = "../../instance"

  compartment_ocid = var.compartment_ocid
  prefix           = local.prefix

  subnet_id       = module.spoke_vcn.subnet_ids["vm"]
  authorized_keys = local.authorized_keys
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
locals {
  authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]
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
