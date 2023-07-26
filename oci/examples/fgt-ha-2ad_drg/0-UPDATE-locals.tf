// local variables
locals {
  prefix = "demo-fgt-drg"

  admin_cidr     = "${chomp(data.http.my-public-ip.response_body)}/32"
  admin_port     = "8443"
  fgt_vcn_cidr   = "172.20.0.0/24"
  spoke_vcn_cidr = "172.30.0.0/24"

  license_type   = "payg"
  license_file_1 = "./licenses/license1.lic"
  license_file_2 = "./licenses/license2.lic"
}