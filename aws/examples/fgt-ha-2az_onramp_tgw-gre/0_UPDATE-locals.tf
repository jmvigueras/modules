#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  count = 2 // number of VPC spokes attached to TGW
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  prefix = "demo-fgt-tgw-gre"
  region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
  #-----------------------------------------------------------------------------------------------------
  # FGT
  #-----------------------------------------------------------------------------------------------------
  admin_port    = "8443"
  admin_cidr    = "${chomp(data.http.my-public-ip.response_body)}/32"
  instance_type = "c6i.large"
  fgt_build     = "build1517"
  license_type  = "payg"

  onramp = {
    id      = "fgt"
    cidr    = "172.30.0.0/23"
    bgp-asn = "65000"
  }

  vpc-spoke_cidr = ["172.30.100.0/23", module.fgt_onramp_vpc.subnet_az1_cidrs["bastion"]]

  tgw_bgp-asn     = "65515"
  tgw_cidr        = ["172.30.10.0/24"]
  tgw_inside_cidr = ["169.254.100.0/29", "169.254.101.0/29"]
}
