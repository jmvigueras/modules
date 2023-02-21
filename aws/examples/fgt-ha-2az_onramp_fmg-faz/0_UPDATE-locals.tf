#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  count = 2

  prefix        = "demo-fgt-fmg-faz"
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

  vpc-spoke_cidr = [module.fgt_onramp_vpc.subnet_az1_cidrs["bastion"]]
}
