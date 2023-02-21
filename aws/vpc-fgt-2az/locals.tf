locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_az1_mgmt_cidr    = cidrsubnet(var.vpc-sec_cidr, 4, 0)
  subnet_az1_public_cidr  = cidrsubnet(var.vpc-sec_cidr, 4, 1)
  subnet_az1_private_cidr = cidrsubnet(var.vpc-sec_cidr, 4, 2)
  subnet_az1_tgw_cidr     = cidrsubnet(var.vpc-sec_cidr, 4, 3)
  subnet_az1_gwlb_cidr    = cidrsubnet(var.vpc-sec_cidr, 4, 4)
  subnet_az1_bastion_cidr = cidrsubnet(var.vpc-sec_cidr, 4, 5)

  subnet_az2_mgmt_cidr    = cidrsubnet(var.vpc-sec_cidr, 4, 8)
  subnet_az2_public_cidr  = cidrsubnet(var.vpc-sec_cidr, 4, 9)
  subnet_az2_private_cidr = cidrsubnet(var.vpc-sec_cidr, 4, 10)
  subnet_az2_tgw_cidr     = cidrsubnet(var.vpc-sec_cidr, 4, 11)
  subnet_az2_gwlb_cidr    = cidrsubnet(var.vpc-sec_cidr, 4, 12)
  subnet_az2_bastion_cidr = cidrsubnet(var.vpc-sec_cidr, 4, 13)

  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip    = cidrhost(local.subnet_az1_mgmt_cidr, 10)
  fgt-1_ni_public_ip  = cidrhost(local.subnet_az1_public_cidr, 10)
  fgt-1_ni_private_ip = cidrhost(local.subnet_az1_private_cidr, 10)

  fgt-2_ni_mgmt_ip    = cidrhost(local.subnet_az2_mgmt_cidr, 11)
  fgt-2_ni_public_ip  = cidrhost(local.subnet_az2_public_cidr, 11)
  fgt-2_ni_private_ip = cidrhost(local.subnet_az2_private_cidr, 11)

  bastion_az1_ni_ip = cidrhost(local.subnet_az1_bastion_cidr, 10)
  bastion_az2_ni_ip = cidrhost(local.subnet_az2_bastion_cidr, 11)

  faz_az1_ni_public_ip  = cidrhost(local.subnet_az1_public_cidr, 12)
  faz_az1_ni_private_ip = cidrhost(local.subnet_az1_bastion_cidr, 12)
  fmg_az1_ni_public_ip  = cidrhost(local.subnet_az1_public_cidr, 13)
  fmg_az1_ni_private_ip = cidrhost(local.subnet_az1_bastion_cidr, 13)

  # ----------------------------------------------------------------------------------
  # FGT IPs (NOT UPDATE)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ips    = [local.fgt-1_ni_mgmt_ip]
  fgt-1_ni_public_ips  = [local.fgt-1_ni_public_ip]
  fgt-1_ni_private_ips = [local.fgt-1_ni_private_ip]

  fgt-2_ni_mgmt_ips    = [local.fgt-2_ni_mgmt_ip]
  fgt-2_ni_public_ips  = [local.fgt-2_ni_public_ip]
  fgt-2_ni_private_ips = [local.fgt-2_ni_private_ip]

  bastion_az1_ni_ips = [local.bastion_az1_ni_ip]
  bastion_az2_ni_ips = [local.bastion_az2_ni_ip]

  faz_az1_ni_public_ips  = [local.faz_az1_ni_public_ip]
  faz_az1_ni_private_ips = [local.faz_az1_ni_private_ip]
  fmg_az1_ni_public_ips  = [local.fmg_az1_ni_public_ip]
  fmg_az1_ni_private_ips = [local.fmg_az1_ni_private_ip]
}