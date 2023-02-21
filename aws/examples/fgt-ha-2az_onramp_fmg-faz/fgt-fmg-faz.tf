#------------------------------------------------------------------------------
# Create FGT cluster onramp
# - Create FGT onramp config (FGSP Active-Active)
# - Create FGT instance
# - Create VPC onramp to FGT
#------------------------------------------------------------------------------
// Create FGT config
module "fgt_onramp_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_active_cidrs  = module.fgt_onramp_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_onramp_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_onramp_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_onramp_vpc.fgt-passive-ni_ips

  config_fgcp = true
  config_fmg  = true
  config_faz  = true
  fmg_ip      = module.fgt_onramp_vpc.fmg_ni_ips["private"]
  faz_ip      = module.fgt_onramp_vpc.faz_ni_ips["private"]

  vpc-spoke_cidr = local.vpc-spoke_cidr
}

// Create FGT
module "fgt_onramp" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-onramp"
  region        = local.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_onramp_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_onramp_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_onramp_config.fgt_config_1
  fgt_config_2       = module.fgt_onramp_config.fgt_config_2

  fgt_passive = true
}

// Create VPC FGT
module "fgt_onramp_vpc" {
  source = "../../vpc-fgt-2az"

  prefix     = "${local.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-sec_cidr = local.fgt_vpc_cidr
}

#------------------------------------------------------------------------------
# Create FAZ and FMG
#------------------------------------------------------------------------------
// Create FAZ
module "faz" {
  source = "../../faz"

  prefix         = local.prefix
  region         = local.region
  keypair        = aws_key_pair.keypair.key_name
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  license_type = "byol"
  license_file = "./licenses/licenseFAZ.lic"

  faz_ni_ids = module.fgt_onramp_vpc.faz_ni_ids
  faz_ni_ips = module.fgt_onramp_vpc.faz_ni_ips
  subnet_cidrs = {
    public  = module.fgt_onramp_vpc.subnet_az1_cidrs["public"]
    private = module.fgt_onramp_vpc.subnet_az1_cidrs["bastion"]
  }
}
// Create FMG
module "fmg" {
  source = "../../fmg"

  prefix         = local.prefix
  region         = local.region
  keypair        = aws_key_pair.keypair.key_name
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  license_type = "byol"
  license_file = "./licenses/licenseFMG.lic"

  fmg_ni_ids = module.fgt_onramp_vpc.fmg_ni_ids
  fmg_ni_ips = module.fgt_onramp_vpc.fmg_ni_ips
  subnet_cidrs = {
    public  = module.fgt_onramp_vpc.subnet_az1_cidrs["public"]
    private = module.fgt_onramp_vpc.subnet_az1_cidrs["bastion"]
  }
}