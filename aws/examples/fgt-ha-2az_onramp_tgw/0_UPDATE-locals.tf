#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  count = 2

  prefix        = "fgt-tgw-onramp"
  admin_port    = "8443"
  admin_cidr    = "${chomp(data.http.my-public-ip.body)}/32"
  instance_type = "c6i.large"
  fgt_build     = "build1396"
  license_type  = "payg"

  region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }

  fgt_vpc_cidr = "172.30.0.0/24"

  vpc-spoke_cidr = "172.30.100.0/23"

  tgw_bgp-asn     = "65515"
  tgw_cidr        = ["172.30.10.0/24"]
  tgw_inside_cidr = ["169.254.100.0/29", "169.254.101.0/29"]
}
