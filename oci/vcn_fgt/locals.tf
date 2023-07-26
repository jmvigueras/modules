locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_public_cidr  = cidrsubnet(var.vcn_cidr, 2, 0)
  subnet_private_cidr = cidrsubnet(var.vcn_cidr, 2, 1)
  subnet_mgmt_cidr    = cidrsubnet(var.vcn_cidr, 2, 2)
  subnet_bastion_cidr = cidrsubnet(var.vcn_cidr, 2, 3)
  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt_ni_public_ip_float  = cidrhost(local.subnet_public_cidr, 9)
  fgt_ni_private_ip_float = cidrhost(local.subnet_private_cidr, 9)

  fgt_1_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 10)
  fgt_1_ni_public_ip  = cidrhost(local.subnet_public_cidr, 10)
  fgt_1_ni_private_ip = cidrhost(local.subnet_private_cidr, 10)

  fgt_2_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 11)
  fgt_2_ni_public_ip  = cidrhost(local.subnet_public_cidr, 11)
  fgt_2_ni_private_ip = cidrhost(local.subnet_private_cidr, 11)
  # ----------------------------------------------------------------------------------
  # FAZ and FMG
  # ----------------------------------------------------------------------------------
  faz_ni_public_ip  = cidrhost(local.subnet_public_cidr, 12)
  faz_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 12)
  fmg_ni_public_ip  = cidrhost(local.subnet_public_cidr, 13)
  fmg_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 13)
  # ----------------------------------------------------------------------------------
  # iLB
  # ----------------------------------------------------------------------------------
  ilb_ip = cidrhost(local.subnet_private_cidr, 9)
  # ----------------------------------------------------------------------------------
  # Bastion VM
  # ----------------------------------------------------------------------------------
  bastion_ni_ip = cidrhost(local.subnet_bastion_cidr, 10)
}