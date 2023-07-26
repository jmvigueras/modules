// Create new DRG
module "drg" {
  source = "../"

  compartment_ocid = var.compartment_ocid
  prefix           = local.prefix
}

