locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_mgmt_cidr        = cidrsubnet(var.vnet-fgt_cidr, 3, 1)
  subnet_public_cidr      = cidrsubnet(var.vnet-fgt_cidr, 3, 2)
  subnet_private_cidr     = cidrsubnet(var.vnet-fgt_cidr, 3, 3)
  subnet_bastion_cidr     = cidrsubnet(var.vnet-fgt_cidr, 3, 4)
  subnet_vgw_cidr         = cidrsubnet(var.vnet-fgt_cidr, 3, 5)
  subnet_routeserver_cidr = cidrsubnet(var.vnet-fgt_cidr, 3, 6)

  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 10)
  fgt-1_ni_public_ip  = cidrhost(local.subnet_public_cidr, 10)
  fgt-1_ni_private_ip = cidrhost(local.subnet_private_cidr, 10)

  fgt-2_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 11)
  fgt-2_ni_public_ip  = cidrhost(local.subnet_public_cidr, 11)
  fgt-2_ni_private_ip = cidrhost(local.subnet_private_cidr, 11)
}