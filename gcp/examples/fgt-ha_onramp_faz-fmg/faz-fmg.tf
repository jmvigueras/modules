#------------------------------------------------------------------------------------------------------------
# Create FAZ instance
#------------------------------------------------------------------------------------------------------------
module "faz" {
  source = "../../faz"

  prefix  = local.prefix
  region  = local.region
  zone    = local.zone1
  machine = local.faz-fmg_machine

  rsa-public-key = trimspace(tls_private_key.ssh-rsa.public_key_openssh)
  gcp-user_name  = split("@", data.google_client_openid_userinfo.me.email)[0]

  subnet_names = {
    public  = module.fgt_vpc.subnet_names["public"]
    private = module.fgt_vpc.subnet_names["bastion"]
  }
  subnet_cidrs = {
    public  = module.fgt_vpc.subnet_cidrs["public"]
    private = module.fgt_vpc.subnet_cidrs["bastion"]
  }

  faz_ni_ips = module.fgt_vpc.faz_ni_ips

  license_file = "./licenses/licenseFAZ.lic"
}

#------------------------------------------------------------------------------------------------------------
# Create FMG instance
#------------------------------------------------------------------------------------------------------------
module "fmg" {
  source = "../../fmg"

  prefix  = local.prefix
  region  = local.region
  zone    = local.zone1
  machine = local.faz-fmg_machine

  rsa-public-key = trimspace(tls_private_key.ssh-rsa.public_key_openssh)
  gcp-user_name  = split("@", data.google_client_openid_userinfo.me.email)[0]

  subnet_names = {
    public  = module.fgt_vpc.subnet_names["public"]
    private = module.fgt_vpc.subnet_names["bastion"]
  }
  subnet_cidrs = {
    public  = module.fgt_vpc.subnet_cidrs["public"]
    private = module.fgt_vpc.subnet_cidrs["bastion"]
  }

  fmg_ni_ips = module.fgt_vpc.fmg_ni_ips

  license_file = "./licenses/licenseFMG.lic"
}