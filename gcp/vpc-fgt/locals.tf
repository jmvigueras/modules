locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_public_cidr  = cidrsubnet(var.vpc-sec_cidr, 3, 0)
  subnet_proxy_cidr   = cidrsubnet(var.vpc-sec_cidr, 3, 1)
  subnet_private_cidr = cidrsubnet(var.vpc-sec_cidr, 3, 2)
  subnet_bastion_cidr = cidrsubnet(var.vpc-sec_cidr, 3, 3)
  subnet_mgmt_cidr    = cidrsubnet(var.vpc-sec_cidr, 3, 4)
  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip     = cidrhost(local.subnet_mgmt_cidr, 10)
  fgt-1_ni_public_ip   = cidrhost(local.subnet_public_cidr, 10)
  fgt-1_ni_private_ip  = cidrhost(local.subnet_private_cidr, 10)

  fgt-2_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 11)
  fgt-2_ni_public_ip  = cidrhost(local.subnet_public_cidr, 11)
  fgt-2_ni_private_ip = cidrhost(local.subnet_private_cidr, 11)
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
  # NCC
  # ----------------------------------------------------------------------------------
  ncc_private_ips = [
    cidrhost(local.subnet_private_cidr, 5),
    cidrhost(local.subnet_private_cidr, 6)
  ]
  ncc_public_ips = [
    cidrhost(local.subnet_public_cidr, 5),
    cidrhost(local.subnet_public_cidr, 6)
  ]
  # ----------------------------------------------------------------------------------
  # Bastion VM
  # ----------------------------------------------------------------------------------
  bastion_ni_ip = cidrhost(local.subnet_bastion_cidr, 10)
}