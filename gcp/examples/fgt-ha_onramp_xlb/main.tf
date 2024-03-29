#------------------------------------------------------------------------------------------------------------
# Create VPCs and subnets Fortigate
# - VPC for MGMT and HA interface
# - VPC for Public interface
# - VPC for Private interface  
#------------------------------------------------------------------------------------------------------------
module "fgt_vpc" {
  source = "../../vpc-fgt"

  region = local.region
  prefix = local.prefix

  vpc-sec_cidr = local.onramp["cidr"]
}
#------------------------------------------------------------------------------------------------------------
# Create FGT cluster config
#------------------------------------------------------------------------------------------------------------
module "fgt_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh-rsa.public_key_openssh)

  subnet_cidrs       = module.fgt_vpc.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_vpc.fgt-passive-ni_ips

  config_fgcp  = local.cluster_type == "fgcp" ? true : false
  config_fgsp  = local.cluster_type == "fgsp" ? true : false
  config_spoke = true
  config_xlb   = true
  spoke        = local.onramp
  ilb_ip       = module.fgt_vpc.ilb_ip

  vpc-spoke_cidr = concat(local.vpc_spoke-subnet_cidrs, [module.fgt_vpc.subnet_cidrs["bastion"]])
}
#------------------------------------------------------------------------------------------------------------
# Create FGT cluster instances
#------------------------------------------------------------------------------------------------------------
module "fgt" {
  source = "../../fgt-ha"

  prefix = local.prefix
  region = local.region
  zone1  = local.zone1
  zone2  = local.zone2

  machine        = local.machine
  rsa-public-key = trimspace(tls_private_key.ssh-rsa.public_key_openssh)
  gcp-user_name  = split("@", data.google_client_openid_userinfo.me.email)[0]
  license_type   = local.license_type

  subnet_names          = module.fgt_vpc.subnet_names
  fgt-active-ni_ips     = module.fgt_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips    = module.fgt_vpc.fgt-passive-ni_ips

  fgt_config_1 = module.fgt_config.fgt_config_1
  fgt_config_2 = module.fgt_config.fgt_config_2

  config_fgsp = local.cluster_type == "fgsp" ? true : false

  fgt_passive = local.fgt_passive
}
#------------------------------------------------------------------------------------------------------------
# Create VPC spokes peered to VPC FGT
#------------------------------------------------------------------------------------------------------------
module "vpc_spoke" {
  source = "../../vpc-spoke"

  prefix = local.prefix
  region = local.region

  spoke-subnet_cidrs = local.vpc_spoke-subnet_cidrs
  fgt_vpc_self_link  = module.fgt_vpc.vpc_self_links["private"]
}
#------------------------------------------------------------------------------------------------------------
# Create Internal and External Load Balancer
#------------------------------------------------------------------------------------------------------------
module "xlb" {
  source = "../../xlb"

  prefix = local.prefix
  region = local.region
  zone1  = local.zone1
  zone2  = local.zone1

  vpc_names             = module.fgt_vpc.vpc_names
  subnet_names          = module.fgt_vpc.subnet_names
  ilb_ip                = module.fgt_vpc.ilb_ip
  fgt_active_self_link  = module.fgt.fgt_active_self_link
  fgt_passive_self_link = module.fgt.fgt_passive_self_link[0]
}
#------------------------------------------------------------------------------------------------------------
# Create VM in VPC spokes
#------------------------------------------------------------------------------------------------------------
module "vm_spoke" {
  source = "../../new-instance"

  prefix = local.prefix
  region = local.region
  zone   = local.zone1

  rsa-public-key = trimspace(tls_private_key.ssh-rsa.public_key_openssh)
  gcp-user_name  = split("@", data.google_client_openid_userinfo.me.email)[0]

  subnet_name = module.vpc_spoke.subnet_name
}





#------------------------------------------------------------------------------------------------------------
# Necessary variables
#------------------------------------------------------------------------------------------------------------
// GET deploy public IP for management
data "http" "my-public-ip" {
  url = "http://ifconfig.me/ip"
}

data "google_client_openid_userinfo" "me" {}

resource "tls_private_key" "ssh-rsa" {
  algorithm = "RSA"
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh-rsa.private_key_pem
  filename        = ".ssh/ssh-key.pem"
  file_permission = "0600"
}