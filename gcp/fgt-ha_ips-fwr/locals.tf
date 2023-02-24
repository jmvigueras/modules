locals {
  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip     = cidrhost(var.subnet_cidrs["mgmt"], 10)
  fgt-1_ni_public_ip   = cidrhost(var.subnet_cidrs["public"], 10)
  fgt-1_ni_private_ip  = cidrhost(var.subnet_cidrs["private"], 10)

  fgt-2_ni_mgmt_ip    = cidrhost(var.subnet_cidrs["mgmt"], 11)
  fgt-2_ni_public_ip  = cidrhost(var.subnet_cidrs["public"], 11)
  fgt-2_ni_private_ip = cidrhost(var.subnet_cidrs["private"], 11)
  # ----------------------------------------------------------------------------------
  # FAZ and FMG
  # ----------------------------------------------------------------------------------
  faz_ni_public_ip  = cidrhost(var.subnet_cidrs["public"], 12)
  // faz_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 12)
  fmg_ni_public_ip  = cidrhost(var.subnet_cidrs["public"], 13)
  // fmg_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 13)
  # ----------------------------------------------------------------------------------
  # iLB
  # ----------------------------------------------------------------------------------
  ilb_ip = cidrhost(var.subnet_cidrs["private"], 9)
  # ----------------------------------------------------------------------------------
  # NCC
  # ----------------------------------------------------------------------------------
  ncc_private_ips = [
    cidrhost(var.subnet_cidrs["private"], 5),
    cidrhost(var.subnet_cidrs["private"], 6)
  ]
  ncc_public_ips = [
    cidrhost(var.subnet_cidrs["public"], 5),
    cidrhost(var.subnet_cidrs["public"], 6)
  ]
  # ----------------------------------------------------------------------------------
  # Bastion VM
  # ----------------------------------------------------------------------------------
 // bastion_ni_ip = cidrhost(local.subnet_bastion_cidr, 10)
}