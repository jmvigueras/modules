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
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_active_cidrs  = module.vpc_onramp.subnet_az1_cidrs
  subnet_passive_cidrs = module.vpc_onramp.subnet_az2_cidrs
  fgt-active-ni_ips    = module.vpc_onramp.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.vpc_onramp.fgt-passive-ni_ips

  config_fgcp     = true
  config_tgw-gre  = true
  tgw_inside_cidr = local.tgw_inside_cidr
  tgw_cidr        = local.tgw_cidr
  tgw_bgp-asn     = local.tgw_bgp-asn
  vpc-spoke_cidr  = [local.vpc-spoke_cidr]
}

// Create FGT
module "fgt_onramp" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-onramp"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.vpc_onramp.fgt-active-ni_ids
  fgt-passive-ni_ids = module.vpc_onramp.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_onramp_config.fgt_config_1
  fgt_config_2       = module.fgt_onramp_config.fgt_config_2

  fgt_passive = true
}

#------------------------------------------------------------------------------
# Create ONRAMP
# - create TGW
# - Create VPC onramp (associated to TGW default RT)
# - Create VPC TGW spoke (associated to TGW spoke RT)
# - Create TGW connect (use GRE and dynamic routing to TGW)
# - Create test instances in VPC TGW spoke (2 x Az1 and 2 x Az2)
#------------------------------------------------------------------------------
// Create TGW
module "tgw" {
  source = "../../tgw"

  prefix      = local.prefix
  tgw_cidr    = local.tgw_cidr
  tgw_bgp-asn = local.tgw_bgp-asn
}

// Create VPC FGT
module "vpc_onramp" {
  source = "../../vpc-fgt-ha-2az-tgw"

  prefix     = "${local.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = var.region

  vpc-sec_cidr          = local.fgt_vpc_cidr
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_default_id
  tgw_rt-propagation_id = module.tgw.rt_vpc-spoke_id
}

// Create VPC spoke attached to TGW
module "vpc_tgw-spoke" {
  count  = local.count
  source = "../../vpc-spoke-2az-to-tgw"

  prefix     = "${local.prefix}-tgw-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = var.region

  vpc-spoke_cidr        = cidrsubnet(local.vpc-spoke_cidr, 1, count.index)
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_vpc-spoke_id
  tgw_rt-propagation_id = [module.tgw.rt_default_id, module.tgw.rt-vpc-sec-N-S_id, module.tgw.rt-vpc-sec-E-W_id]
}

// Create TGW connect
module "tgw_connect" {
  source = "../../tgw_connect"

  prefix         = local.prefix
  vpc_tgw-att_id = module.vpc_onramp.vpc_tgw-att_id
  tgw_id         = module.tgw.tgw_id
  peer_bgp-asn   = local.onramp["bgp-asn"]
  peer_ip = [
    module.vpc_onramp.fgt-active-ni_ips["private"],
    module.vpc_onramp.fgt-passive-ni_ips["private"]
  ]
  tgw_inside_cidr   = local.tgw_inside_cidr
  tgw_cidr          = local.tgw_cidr
  rt_propagation_id = [module.tgw.rt_vpc-spoke_id]
}

// Create test VM on VPC TGW spoke
module "vm_onramp_az1" {
  count  = local.count
  source = "../../new-instance"

  prefix  = "${local.prefix}-spoke-${count.index}-az1"
  ni_id   = module.vpc_tgw-spoke[count.index].az1-vm-ni_id
  keypair = aws_key_pair.keypair.key_name
}
module "vm_onramp_az2" {
  count  = local.count
  source = "../../new-instance"

  prefix  = "${local.prefix}-spoke-${count.index}-az2"
  ni_id   = module.vpc_tgw-spoke[count.index].az2-vm-ni_id
  keypair = aws_key_pair.keypair.key_name
}