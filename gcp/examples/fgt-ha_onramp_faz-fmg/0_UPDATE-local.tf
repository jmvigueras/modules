locals {
  #-----------------------------------------------------------------------------------------------------
  # General variables
  #-----------------------------------------------------------------------------------------------------
  region = "europe-west2"
  zone1  = "europe-west2-a"
  zone2  = "europe-west2-a"
  prefix = "demo-fgt-fmg-faz"
  #-----------------------------------------------------------------------------------------------------
  # FGT
  #-----------------------------------------------------------------------------------------------------
  fgt_license_type = "payg"
  fgt_machine      = "n1-standard-4"

  admin_port = "8443"
  admin_cidr = "${chomp(data.http.my-public-ip.response_body)}/32"

  onramp = {
    id      = "fgt"
    cidr    = "172.30.0.0/23" //minimum range to create proxy subnet
    bgp_asn = "65000"
  }
  vpc_spoke-subnet_cidrs = ["172.30.10.0/23"]

  fgt_passive = true
  #-----------------------------------------------------------------------------------------------------
  # FAZ and FMG variables
  #-----------------------------------------------------------------------------------------------------
  faz-fmg_machine  = "n1-standard-4"
  faz_license_file = "./licenses/licenseFAZ.lic"
  fmg_license_file = "./licenses/licenseFMG.lic"
}