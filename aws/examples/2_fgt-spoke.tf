#------------------------------------------------------------------------------
# Create SDWAN spokes to HUBs 
# - Create VPC spoke
# - Create FGT spoke sdwan config (FGCP)
# - Create FGT instance
#------------------------------------------------------------------------------
// Create VPC spoke
module "vpc_spoke" {
  count  = local.count
  source = "../vpc-fgt-ha-2az"

  prefix     = "${var.prefix}-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = var.admin_port
  region     = var.region

  vpc-sec_cidr = cidrsubnet(local.spoke["cidr"], ceil(log(local.count, 2)), count.index)
}

module "fgt_spoke_config" {
  count  = local.count
  source = "../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = module.vpc_spoke[count.index].subnet_az1_cidrs
  subnet_passive_cidrs = module.vpc_spoke[count.index].subnet_az2_cidrs
  fgt-active-ni_ips    = module.vpc_spoke[count.index].fgt-active-ni_ips
  fgt-passive-ni_ips   = module.vpc_spoke[count.index].fgt-passive-ni_ips

  config_fgcp  = true
  config_spoke = true
  spoke = {
    id      = "${local.spoke["id"]}-${count.index + 1}"
    cidr    = cidrsubnet(local.spoke["cidr"], ceil(log(local.count, 2)), count.index)
    bgp-asn = local.hub1["bgp-asn_spoke"]
  }
  hubs = local.hubs
}

module "fgt_spoke" {
  count  = local.count
  source = "../"

  fgt-ami       = var.license_type == "byol" ? data.aws_ami_ids.fgt_amis_byol.ids[0] : data.aws_ami_ids.fgt_amis_payg.ids[0]
  prefix        = "${var.prefix}-spoke-${count.index + 1}"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  fgt-active-ni_ids  = module.vpc_spoke[count.index].fgt-active-ni_ids
  fgt-passive-ni_ids = module.vpc_spoke[count.index].fgt-passive-ni_ids
  fgt_config_1       = module.fgt_spoke_config[count.index].fgt_config_1
  fgt_config_2       = module.fgt_spoke_config[count.index].fgt_config_2
}

