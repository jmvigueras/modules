locals {
  region  = "europe-west2"
  zone1   = "europe-west2-a"
  zone2   = "europe-west2-a"
  prefix  = "demo-jvb"
  machine = "n1-standard-4"

  admin_port   = "8443"
  admin_cidr   = "${chomp(data.http.my-public-ip.body)}/32"
  license_type = "payg"

  onramp = {
    id      = "fgt"
    cidr    = "172.30.0.0/23" //minimum range to create proxy subnet
    bgp-asn = "65000"
  }
  vpc_spoke-subnet_cidrs = ["172.30.10.0/23"]

  fgt_passive = true

  ncc_bgp-asn = "65515"
}