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
  # FGT (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 10)
  fgt-1_ni_public_ip  = cidrhost(local.subnet_public_cidr, 10)
  fgt-1_ni_private_ip = cidrhost(local.subnet_private_cidr, 10)

  fgt-2_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 11)
  fgt-2_ni_public_ip  = cidrhost(local.subnet_public_cidr, 11)
  fgt-2_ni_private_ip = cidrhost(local.subnet_private_cidr, 11)

  fgt-1_ni_mgmt_name    = "${var.prefix}-ni-active-mgmt"
  fgt-1_ni_public_name  = "${var.prefix}-ni-active-public"
  fgt-1_ni_private_name = "${var.prefix}-ni-active-private"
  
  fgt-2_ni_mgmt_name    = "${var.prefix}-ni-passive-mgmt"
  fgt-2_ni_public_name  = "${var.prefix}-ni-passive-public"
  fgt-2_ni_private_name = "${var.prefix}-ni-passive-private"

  fgt-1_ni_public_id = concat(azurerm_network_interface.ni-active-public_xlb.*.id, azurerm_network_interface.ni-active-public_sdn.*.id)[0]
  fgt-2_ni_public_id = concat(azurerm_network_interface.ni-passive-public_xlb.*.id, azurerm_network_interface.ni-passive-public_fgsp.*.id)[0]

  fgt-1_public_ip_name = "${var.prefix}-active-public-ip"
  fgt-2_public_ip_name = "${var.prefix}-passive-public-ip"
}