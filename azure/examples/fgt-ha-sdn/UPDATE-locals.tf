#-------------------------------------------------------------------------------------
# UPDATE necessary variables
#-------------------------------------------------------------------------------------
locals {
  adminusername = "azureadmin"
  adminpassword = "Terraform123#"
  admin_port    = "8443"

  spoke_cidr_vnet = "172.16.0.0/12" // Complete CIDR range VNets in Azure

  vnet-fgt_cidr    = "172.30.0.0/23"    // VNet FGT CIDR
  vnet-spoke_cidrs = ["172.30.20.0/23"] // list of ranges to create VNets spoke peered to FGT VNet (min /23 if included Azure Router Server)
}