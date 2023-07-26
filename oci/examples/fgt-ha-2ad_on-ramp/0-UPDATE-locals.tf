// local variables
locals {
  prefix = "demo-fgt-ha"

  admin_cidr = "0.0.0.0/0"
  admin_port = "8443"
  vcn_cidr   = "172.20.0.0/24"

  license_type   = "byol"
  license_file_1 = "./licenses/license1.lic"
  license_file_2 = "./licenses/license2.lic"
}