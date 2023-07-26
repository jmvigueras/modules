// Create new VNC
module "fgt_vcn" {
  source = "../"

  compartment_ocid = var.compartment_ocid
  
  region     = var.region
  prefix     = local.prefix
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port

  vcn_cidr = local.vcn_cidr
}