#------------------------------------------------------------------------------
# Create FGT cluster onramp
# - Create FGT onramp config (FGSP Active-Active)
# - Create FGT instance
#------------------------------------------------------------------------------
// Create FGT config
module "fgt_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_active_cidrs  = module.fgt_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_vpc.fgt-passive-ni_ips

  config_fgcp    = true
}

// Create FGT
module "fgt" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-onramp"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_config.fgt_config_1
  fgt_config_2       = module.fgt_config.fgt_config_2

  fgt_passive = true
}

// Create VPC FGT
module "fgt_vpc" {
  source = "../../vpc-fgt-ha-2az"

  prefix     = "${local.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = var.region

  vpc-sec_cidr = local.fgt_vpc_cidr
}