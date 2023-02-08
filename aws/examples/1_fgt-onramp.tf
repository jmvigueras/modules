#------------------------------------------------------------------------------
# Create ONRAMP AWS 
# - create TGW
# - create GWLB
# - Create VPC onramp (associated to TGW)
# - Create VPC TGW spoke (associated to TGW)
# - Create TGW connect (use GRE and dynamic routing to TGW)
# - Create FGT onramp config (FGCP)
# - Create FGT instance
# - Create test instances in VPC TGW spoke 
#------------------------------------------------------------------------------
// Create TGW
module "tgw" {
  source = "../tgw"

  prefix      = var.prefix
  tgw_cidr    = local.tgw_cidr
  tgw_bgp-asn = local.tgw_bgp-asn
}

// Create VPC FGT
module "vpc_onramp" {
  source = "../vpc-fgt-ha-2az-tgw"

  prefix     = "${var.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = var.admin_port
  region     = var.region

  vpc-sec_cidr          = local.onramp["cidr"]
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_default_id
  tgw_rt-propagation_id = module.tgw.rt_vpc-spoke_id
}

// Create VPC spoke attached to TGW
module "vpc_tgw-spoke" {
  count  = local.count
  source = "../vpc-spoke-2az-to-tgw"

  prefix     = "${var.prefix}-tgw-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = var.admin_port
  region     = var.region

  vpc-spoke_cidr        = cidrsubnet(local.vpc-spoke_cidr, 1, count.index)
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_vpc-spoke_id
  tgw_rt-propagation_id = [module.tgw.rt_default_id, module.tgw.rt-vpc-sec-N-S_id, module.tgw.rt-vpc-sec-E-W_id]
}

// Create TGW connect
module "tgw_connect" {
  source = "../tgw_connect"

  prefix         = var.prefix
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

// Create FGT config
module "fgt_onramp_config" {
  source = "../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = module.vpc_onramp.subnet_az1_cidrs
  subnet_passive_cidrs = module.vpc_onramp.subnet_az2_cidrs
  fgt-active-ni_ips    = module.vpc_onramp.fgt-active-ni_ips
  fgt-passive-ni_ips   = module.vpc_onramp.fgt-passive-ni_ips

  config_fgcp     = true
  config_spoke    = true
  config_tgw-gre  = true
  spoke           = local.onramp
  hubs            = local.hubs
  tgw_inside_cidr = local.tgw_inside_cidr
  tgw_cidr        = local.tgw_cidr
  tgw_bgp-asn     = local.tgw_bgp-asn
  vpc-spoke_cidr  = [local.vpc-spoke_cidr]
}

// Create FGT
module "fgt_onramp" {
  source = "../"

  fgt-ami       = var.license_type == "byol" ? data.aws_ami_ids.fgt_amis_byol.ids[0] : data.aws_ami_ids.fgt_amis_payg.ids[0]
  prefix        = "${var.prefix}-onramp"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  fgt-active-ni_ids  = module.vpc_onramp.fgt-active-ni_ids
  fgt-passive-ni_ids = module.vpc_onramp.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_onramp_config.fgt_config_1
  fgt_config_2       = module.fgt_onramp_config.fgt_config_2

  //fgt_passive = true  
}

// Create test VM on VPC TGW spoke
module "vm_onramp" {
  count  = local.count
  source = "../new-instance"

  prefix  = "${var.prefix}-onramp"
  ni_id   = [module.vpc_tgw-spoke[count.index].az1-vm-ni_id]
  keypair = aws_key_pair.keypair.key_name
}