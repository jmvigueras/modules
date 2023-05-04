#------------------------------------------------------------------------------
# Create HUB 1
# - VPC FGT hub
# - config FGT hub (FGSP)
# - FGT hub
# - Create test instances in VPC TGW spoke (2 x Az1 and 2 x Az2)
#------------------------------------------------------------------------------
// Create VPC for hub
module "fgt_hub_vpc" {
  source = "../../vpc-fgt-2az"

  prefix     = "${local.prefix}-hub"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-sec_cidr = local.fgt_hub_vpc_cidr
}
// Create config for FGT hub (FGSP)
module "fgt_hub_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_active_cidrs  = module.fgt_hub_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_hub_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_hub_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_hub_vpc.fgt-passive-ni_ips

  config_fgcp = true
  config_hub  = true
  hub         = local.hub

  vpc-spoke_cidr = [module.fgt_hub_vpc.subnet_az1_cidrs["bastion"], module.fgt_hub_vpc.subnet_az2_cidrs["bastion"]]
}
// Create FGT instances (Active-Active)
module "fgt_hub" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-hub"
  region        = local.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_hub_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_hub_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_hub_config.fgt_config_1
  fgt_config_2       = module.fgt_hub_config.fgt_config_2

  fgt_passive = false
}
// Create VM in bastion subnet
module "vm_hub" {
  source = "../../new-instance"

  prefix  = "${local.prefix}-fgt-hub"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.fgt_hub_vpc.subnet_az1_ids["bastion"]
  security_groups = [module.fgt_hub_vpc.nsg_ids["bastion"]]
}