#-----------------------------------------------------------------------------------------------------
# FortiGate Terraform deployment
# Active Passive High Availability MultiAZ with AWS Transit Gateway with VPC standard attachment
#-----------------------------------------------------------------------------------------------------
locals {

  prefix     = "demo-fgt-1az"
  admin_port = "8443"
  admin_cidr = "${chomp(data.http.my-public-ip.body)}/32"

  instance_type = "c6i.large"
  fgt_build     = "build1396"
  license_type  = "payg"

  region = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1a"  // same AZ id as AZ1 for a single AZ deployment
  }

  fgt_vpc_cidr = "172.30.0.0/24"
}