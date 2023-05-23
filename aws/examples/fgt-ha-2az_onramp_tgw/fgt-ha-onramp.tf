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

  subnet_active_cidrs  = module.fgt_onramp_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_onramp_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_onramp_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_onramp_vpc.fgt-passive-ni_ips

  config_fgcp  = true
  config_spoke = true
  spoke        = local.onramp

  vpc-spoke_cidr = concat(local.vpc_tgw_spoke_cidrs, [module.fgt_onramp_vpc.subnet_az1_cidrs["bastion"]])
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

#------------------------------------------------------------------------------
# Create TGW and VPC
# - create TGW
# - Create VPC onramp (associated to TGW default RT)
# - Create VPC TGW spoke (associated to TGW spoke RT)
# - Create TGW connect (use GRE and dynamic routing to TGW)
#------------------------------------------------------------------------------
// Create TGW
module "tgw" {
  source = "../../tgw"

  prefix = local.prefix

  tgw_cidr    = local.tgw_cidr
  tgw_bgp-asn = local.tgw_bgp-asn
}
// Create VPC FGT
module "fgt_onramp_vpc" {
  source = "../../vpc-fgt-2az_tgw"

  prefix     = "${local.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-sec_cidr          = local.onramp["cidr"]
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_default_id
  tgw_rt-propagation_id = module.tgw.rt_vpc-spoke_id
}
// Create VPC spoke attached to TGW
module "vpc_tgw-spoke" {
  count  = length(local.vpc_tgw_spoke_cidrs)
  source = "../../vpc-spoke-2az-to-tgw"

  prefix     = "${local.prefix}-tgw-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-spoke_cidr        = local.vpc_tgw_spoke_cidrs[count.index]
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_vpc-spoke_id
  tgw_rt-propagation_id = [module.tgw.rt_default_id, module.tgw.rt-vpc-sec-N-S_id, module.tgw.rt-vpc-sec-E-W_id]
}
// Create static route in TGW RouteTable Spoke
resource "aws_ec2_transit_gateway_route" "spoke_tgw_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.fgt_onramp_vpc.vpc_tgw-att_id
  transit_gateway_route_table_id = module.tgw.rt_vpc-spoke_id
}

#------------------------------------------------------------------------------
# Create test instances in VPC TGW spoke (2 x Az1 and 2 x Az2)
#------------------------------------------------------------------------------
// Create test VM on VPC TGW spoke
module "vm_onramp_az1" {
  count  = length(local.vpc_tgw_spoke_cidrs)
  source = "../../new-instance"

  prefix  = "${local.prefix}-spoke-${count.index}-az1"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.vpc_tgw-spoke[count.index].subnet_az1_ids["vm"]
  security_groups = [module.vpc_tgw-spoke[count.index].nsg_ids["vm"]]
}
module "vm_onramp_az2" {
  count  = length(local.vpc_tgw_spoke_cidrs)
  source = "../../new-instance"

  prefix = "${local.prefix}-spoke-${count.index}-az2"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.vpc_tgw-spoke[count.index].subnet_az2_ids["vm"]
  security_groups = [module.vpc_tgw-spoke[count.index].nsg_ids["vm"]]
}