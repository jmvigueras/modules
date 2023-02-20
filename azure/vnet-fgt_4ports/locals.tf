locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_ha_cidr          = cidrsubnet(var.vpc-sec_cidr, 3, 0)
  subnet_mgmt_cidr        = cidrsubnet(var.vpc-sec_cidr, 3, 1)
  subnet_public_cidr      = cidrsubnet(var.vpc-sec_cidr, 3, 2)
  subnet_private_cidr     = cidrsubnet(var.vpc-sec_cidr, 3, 3)
  subnet_bastion_cidr     = cidrsubnet(var.vpc-sec_cidr, 3, 4)
  subnet_vgw_cidr         = cidrsubnet(var.vpc-sec_cidr, 3, 5)
  subnet_routeserver_cidr = cidrsubnet(var.vpc-sec_cidr, 3, 6)

  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_ha_ip       = cidrhost(local.subnet_ha_cidr, 10)
  fgt-1_ni_mgmt_ip     = cidrhost(local.subnet_mgmt_cidr, 10)
  fgt-1_ni_public_ip   = cidrhost(local.subnet_public_cidr, 10)
  fgt-1_ni_private_ip  = cidrhost(local.subnet_private_cidr, 10)

  fgt-2_ni_ha_ip      = cidrhost(local.subnet_ha_cidr, 11)
  fgt-2_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 11)
  fgt-2_ni_public_ip  = cidrhost(local.subnet_public_cidr, 11)
  fgt-2_ni_private_ip = cidrhost(local.subnet_private_cidr, 11)

  bastion_ni_ip = cidrhost(local.subnet_bastion_cidr, 10)

  faz_ni_public_ip  = cidrhost(local.subnet_public_cidr, 12)
  faz_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 12)
  fmg_ni_public_ip  = cidrhost(local.subnet_public_cidr, 13)
  fmg_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 13)
}