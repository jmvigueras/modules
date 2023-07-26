locals {
  prefix   = "demo-vm"
  vcn_cidr = "172.30.0.0/24" 
}
// Create new VNC
module "vcn" {
  source = "../../spoke_vcn"

  compartment_ocid = var.compartment_ocid
  
  region   = var.region
  prefix   = local.prefix
  vcn_cidr = local.vcn_cidr
}
// Create VM
module "vm" {
  source = "../"
  
  compartment_ocid = var.compartment_ocid
  
  prefix          = local.prefix
  subnet_id       = module.vcn.subnet_ids["vm"]
  authorized_keys = local.authorized_keys
}





#-----------------------------------------------------------------------
# Necessary variables
#-----------------------------------------------------------------------
data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${local.prefix}-ssh-key.pem"
  file_permission = "0600"
}
locals {
  authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]
}
