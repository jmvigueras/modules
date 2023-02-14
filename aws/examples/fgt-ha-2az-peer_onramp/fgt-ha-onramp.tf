#------------------------------------------------------------------------------
# Create FGT cluster onramp
# - Create FGT onramp config (FGSP Active-Active)
# - Create FGT instance
#------------------------------------------------------------------------------
// Create FGT config
module "fgt_onramp_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = module.fgt_onramp_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_onramp_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_onramp_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_onramp_vpc.fgt-passive-ni_ips

  config_fgcp    = true
  config_spoke   = true
  spoke          = local.onramp
  hubs           = local.hubs
  vpc-spoke_cidr = [local.vpc-spoke_cidr]
}

// Create FGT
module "fgt_onramp" {
  source = "../../fgt-ha-2az"

  fgt-ami       = var.license_type == "byol" ? data.aws_ami_ids.fgt_amis_byol.ids[0] : data.aws_ami_ids.fgt_amis_payg.ids[0]
  prefix        = "${local.prefix}-onramp"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  fgt-active-ni_ids  = module.fgt_onramp_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_onramp_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_onramp_config.fgt_config_1
  fgt_config_2       = module.fgt_onramp_config.fgt_config_2

  fgt_passive = true
}

// Create VPC FGT
module "fgt_onramp_vpc" {
  source = "../../vpc-fgt-ha-2az"

  prefix     = "${local.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = var.region

  vpc-sec_cidr = local.onramp["cidr"]
}

// Create VPC spoke attached to TGW
module "fgt_vpc-spoke" {
  count  = local.count
  source = "../../vpc-spoke-2az-to-fgt"

  prefix     = "${local.prefix}-tgw-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = var.region

  vpc-spoke_cidr = cidrsubnet(local.vpc-spoke_cidr, 1, count.index)
  vpc-sec_id     = module.fgt_onramp_vpc.vpc-sec_id
}

// Create test VM on VPC TGW spoke
module "vm_fgt_vpc-spoke" {
  count  = local.count
  source = "../../new-instance"

  prefix  = "${local.prefix}-spoke-${count.index}-az1"
  ni_id   = module.fgt_vpc-spoke[count.index].az1-vm-ni_id
  keypair = aws_key_pair.keypair.key_name
}