#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  prefix = "demo-fgt-2az"
  region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
  #-----------------------------------------------------------------------------------------------------
  # FGT
  #-----------------------------------------------------------------------------------------------------
  admin_port = "8443"
  admin_cidr = "${chomp(data.http.my-public-ip.response_body)}/32"

  instance_type = "c6i.large"
  fgt_build     = "build1575"
  license_type  = "payg"

  fgt_vpc_cidr = "172.30.0.0/24"

  vpc-spoke_cidr = [module.fgt_vpc.subnet_az1_cidrs["bastion"]]
}
