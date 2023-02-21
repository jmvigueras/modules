locals {

  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip    = cidrhost(var.subnet_az1_cidrs["mgmt"], 10)
  fgt-1_ni_public_ip  = cidrhost(var.subnet_az1_cidrs["public"], 10)
  fgt-1_ni_private_ip = cidrhost(var.subnet_az1_cidrs["private"], 10)

  fgt-2_ni_mgmt_ip    = cidrhost(var.subnet_az2_cidrs["mgmt"], 11)
  fgt-2_ni_public_ip  = cidrhost(var.subnet_az2_cidrs["public"], 11)
  fgt-2_ni_private_ip = cidrhost(var.subnet_az2_cidrs["private"], 11)

  # ----------------------------------------------------------------------------------
  # FGT IPs (NOT UPDATE)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ips    = [local.fgt-1_ni_mgmt_ip]
  fgt-1_ni_public_ips  = [local.fgt-1_ni_public_ip]
  fgt-1_ni_private_ips = [local.fgt-1_ni_private_ip]

  fgt-2_ni_mgmt_ips    = [local.fgt-2_ni_mgmt_ip]
  fgt-2_ni_public_ips  = [local.fgt-2_ni_public_ip]
  fgt-2_ni_private_ips = [local.fgt-2_ni_private_ip]
}