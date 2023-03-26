#------------------------------------------------------------------------------
# Create HUB 1
# - VPC FGT hub1
# - config FGT hub1 (FGSP)
# - FGT hub1
# - create TGW
# - Create VPC TGW spoke (associated to TGW spoke RT)
# - Create TGW connect (use GRE and dynamic routing to TGW)
# - Create test instances in VPC TGW spoke (2 x Az1 and 2 x Az2)
#------------------------------------------------------------------------------
// Create VPC for HUB1
module "fgt_hub1_vpc" {
  source = "../../vpc-fgt-2az_tgw"

  prefix     = "${local.prefix}-hub1"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-sec_cidr          = local.hub1_fgt_vpc_cidr
  tgw_id                = module.tgw_hub1.tgw_id
  tgw_rt-association_id = module.tgw_hub1.rt_default_id
  tgw_rt-propagation_id = module.tgw_hub1.rt_vpc-spoke_id
}
// Create config for FGT HUB1 (FGSP)
module "fgt_hub1_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_active_cidrs  = module.fgt_hub1_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_hub1_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_hub1_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_hub1_vpc.fgt-passive-ni_ips

  config_fgsp     = true
  config_hub      = true
  config_tgw-gre  = true
  hub             = local.hub1
  tgw_inside_cidr = local.tgw_inside_cidr
  tgw_cidr        = local.tgw_cidr
  tgw_bgp-asn     = local.tgw_bgp-asn
  vpc-spoke_cidr  = [local.hub1_spoke_vpc_cidr, module.fgt_hub1_vpc.subnet_az1_cidrs["bastion"], module.fgt_hub1_vpc.subnet_az2_cidrs["bastion"]]
}
// Create FGT instances (Active-Active)
module "fgt_hub1" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-hub1"
  region        = local.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_hub1_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_hub1_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_hub1_config.fgt_config_1
  fgt_config_2       = module.fgt_hub1_config.fgt_config_2

  fgt_ha_fgsp = true
  fgt_passive = true
}
// Create VM in bastion subnet
module "vm_fgt_hub1" {
  source = "../../new-instance"

  prefix  = "${local.prefix}-fgt-hub1"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.fgt_hub1_vpc.subnet_az1_ids["bastion"]
  security_groups = [module.fgt_hub1_vpc.nsg_ids["bastion"]]
}
// Create TGW
module "tgw_hub1" {
  source = "../../tgw"

  prefix      = local.prefix
  tgw_cidr    = local.tgw_cidr
  tgw_bgp-asn = local.tgw_bgp-asn
}
// Create VPC spoke attached to TGW
module "tgw_hub1_vpc-spoke" {
  count  = local.count
  source = "../../vpc-spoke-2az-to-tgw"

  prefix     = "${local.prefix}-tgw-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-spoke_cidr        = cidrsubnet(local.hub1_spoke_vpc_cidr, ceil(log(local.count, 2)), count.index)
  tgw_id                = module.tgw_hub1.tgw_id
  tgw_rt-association_id = module.tgw_hub1.rt_vpc-spoke_id
  tgw_rt-propagation_id = [module.tgw_hub1.rt_default_id, module.tgw_hub1.rt-vpc-sec-N-S_id, module.tgw_hub1.rt-vpc-sec-E-W_id]
}
// Create TGW connect
module "tgw_hub1_connect" {
  source = "../../tgw_connect"

  prefix         = local.prefix
  vpc_tgw-att_id = module.fgt_hub1_vpc.vpc_tgw-att_id
  tgw_id         = module.tgw_hub1.tgw_id
  peer_bgp-asn   = local.hub1["bgp-asn_hub"]
  peer_ip = [
    module.fgt_hub1_vpc.fgt-active-ni_ips["private"],
    module.fgt_hub1_vpc.fgt-passive-ni_ips["private"]
  ]
  tgw_inside_cidr   = local.tgw_inside_cidr
  tgw_cidr          = local.tgw_cidr
  rt_propagation_id = [module.tgw_hub1.rt_vpc-spoke_id]
}
// Create VM in spoke vpc to TGW AZ1
module "vm_tgw_hub1" {
  count  = local.count
  source = "../../new-instance"

  prefix  = "${local.prefix}-tgw-hub1"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.tgw_hub1_vpc-spoke[count.index].subnet_az1_ids["vm"]
  security_groups = [module.tgw_hub1_vpc-spoke[count.index].nsg_ids["vm"]]
}

#------------------------------------------------------------------------------
# Create HUB 2
# - vpc hub2
# - config FGT hub2 (FGCP)
# - FGT hub2
#------------------------------------------------------------------------------
// Create VPC for HUB2
module "fgt_hub2_vpc" {
  source = "../../vpc-fgt-2az"

  prefix     = "${local.prefix}-hub2"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-sec_cidr = local.hub2_fgt_vpc_cidr
}
// Create config for FGT HUB2 (FGCP)
module "fgt_hub2_config" {
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = trimspace(tls_private_key.ssh.public_key_openssh)
  api_key        = trimspace(random_string.api_key.result)

  subnet_active_cidrs  = module.fgt_hub2_vpc.subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_hub2_vpc.subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_hub2_vpc.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_hub2_vpc.fgt-passive-ni_ips

  config_fgcp = true
  config_hub  = true
  hub         = local.hub2
}
// Create FGT instances (Active-Passive)
module "fgt_hub2" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-hub2"
  region        = local.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_hub2_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_hub2_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_hub2_config.fgt_config_1
  fgt_config_2       = module.fgt_hub2_config.fgt_config_2
}
// Create VM in bastion subnet FGT
module "vm_fgt_hub2" {
  source = "../../new-instance"

  prefix  = "${local.prefix}-hub2"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.fgt_hub2_vpc.subnet_az1_ids["bastion"]
  security_groups = [module.fgt_hub2_vpc.nsg_ids["bastion"]]
}