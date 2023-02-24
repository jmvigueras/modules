locals {
  #------------------------------------------------------------------------------
  # IPs of network interfaces
  #------------------------------------------------------------------------------
  ni-active-mgmt_ip    = cidrhost(var.subnet_cidrs["mgmt"], 10)
  ni-active-public_ip  = cidrhost(var.subnet_cidrs["public"], 10)
  ni-active-private_ip = cidrhost(var.subnet_cidrs["private"], 10)
  ni-active-ha_ip      = cidrhost(var.subnet_cidrs["ha"], 10)

  ni-passive-mgmt_ip    = cidrhost(var.subnet_cidrs["mgmt"], 11)
  ni-passive-public_ip  = cidrhost(var.subnet_cidrs["public"], 11)
  ni-passive-private_ip = cidrhost(var.subnet_cidrs["private"], 11)
  ni-passive-ha_ip      = cidrhost(var.subnet_cidrs["ha"], 11)
}