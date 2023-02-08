#------------------------------------------------------------------------------
# Create HUB 1
# - vpc hub1
# - config FGT hub1
# - FGT hub1
#------------------------------------------------------------------------------
// Create VPC for HUB1
module "vpc_hub1" {
  source = "../vpc-fgt-ha-2az"

  prefix     = "${var.prefix}-hub1"
  admin_cidr = local.admin_cidr
  admin_port = var.admin_port
  region     = var.region

  vpc-sec_cidr = local.hub1["cidr"]
}
// Create config for FGT HUB1 (FGSP)
module "fgt_hub1_config" {
  source = "../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = module.vpc_hub1.subnet_az1_cidrs
  subnet_passive_cidrs = module.vpc_hub1.subnet_az2_cidrs
  fgt-active-ni_ips    = module.vpc_hub1.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.vpc_hub1.fgt-passive-ni_ips

  config_fgcp    = true
  config_hub     = true
  hub            = local.hub1
  hub-peer_vxlan = local.hub1-peer_vxlan
}
// Create FGT instances (Active-Active)
module "fgt_hub1" {
  source = "../"

  fgt-ami       = var.license_type == "byol" ? data.aws_ami_ids.fgt_amis_byol.ids[0] : data.aws_ami_ids.fgt_amis_payg.ids[0]
  prefix        = "${var.prefix}-hub1"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  fgt-active-ni_ids  = module.vpc_hub1.fgt-active-ni_ids
  fgt-passive-ni_ids = module.vpc_hub1.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_hub1_config.fgt_config_1
  fgt_config_2       = module.fgt_hub1_config.fgt_config_2

 // fgt_ha_fgsp = true
 // fgt_passive = true
}

#------------------------------------------------------------------------------
# Create HUB 2
# - vpc hub2
# - config FGT hub2
# - FGT hub2
#------------------------------------------------------------------------------
// Create VPC for HUB2
module "vpc_hub2" {
  source = "../vpc-fgt-ha-2az"

  prefix     = "${var.prefix}-hub2"
  admin_cidr = local.admin_cidr
  admin_port = var.admin_port
  region     = var.region

  vpc-sec_cidr = local.hub2["cidr"]
}
// Create config for FGT HUB2 (FGCP)
module "fgt_hub2_config" {
  source = "../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = module.vpc_hub2.subnet_az1_cidrs
  subnet_passive_cidrs = module.vpc_hub2.subnet_az2_cidrs
  fgt-active-ni_ips    = module.vpc_hub2.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.vpc_hub2.fgt-passive-ni_ips

  config_fgcp    = true
  config_hub     = true
  hub            = local.hub2
  hub-peer_vxlan = local.hub2-peer_vxlan
}
// Create FGT instances (Active-Passive)
module "fgt_hub2" {
  source = "../"

  fgt-ami       = var.license_type == "byol" ? data.aws_ami_ids.fgt_amis_byol.ids[0] : data.aws_ami_ids.fgt_amis_payg.ids[0]
  prefix        = "${var.prefix}-hub2"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  fgt-active-ni_ids  = module.vpc_hub2.fgt-active-ni_ids
  fgt-passive-ni_ids = module.vpc_hub2.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_hub2_config.fgt_config_1
  fgt_config_2       = module.fgt_hub2_config.fgt_config_2

  // fgt_passive = true
}
