#------------------------------------------------------------------------------
# Create SDWAN spokes to SDWAN HUBs (simulated remote sites connected to HUBs)
# - Create VPC spoke
# - Create FGT spoke sdwan config (FGCP)
# - Create FGT instance
#------------------------------------------------------------------------------
// Create VPC spoke
module "fgt_spoke_vpc" {
  count  = local.count
  source = "../../vpc-fgt-ha-2az"

  prefix     = "${local.prefix}-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = var.region

  vpc-sec_cidr = cidrsubnet(local.spoke["cidr"], ceil(log(local.count, 2)), count.index)
}

module "fgt_spoke_config" {
  count  = local.count
  source = "../../fgt-config"

  admin_cidr     = local.admin_cidr
  admin_port     = local.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = random_string.api_key.result

  subnet_active_cidrs  = module.fgt_spoke_vpc[count.index].subnet_az1_cidrs
  subnet_passive_cidrs = module.fgt_spoke_vpc[count.index].subnet_az2_cidrs
  fgt-active-ni_ips    = module.fgt_spoke_vpc[count.index].fgt-active-ni_ips
  fgt-passive-ni_ips   = module.fgt_spoke_vpc[count.index].fgt-passive-ni_ips

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
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-spoke-${count.index + 1}"
  region        = var.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_spoke_vpc[count.index].fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_spoke_vpc[count.index].fgt-passive-ni_ids
  fgt_config_1       = module.fgt_spoke_config[count.index].fgt_config_1
  fgt_config_2       = module.fgt_spoke_config[count.index].fgt_config_2
}
// Create VM in subnet bastion FGT spoke
module "vm_fgt_spoke" {
  count  = local.count
  source = "../../new-instance"

  prefix  = "${local.prefix}-spoke-${count.index + 1}"
  ni_id   = module.fgt_spoke_vpc[count.index].bastion-ni_ids["az1"]
  keypair = aws_key_pair.keypair.key_name
}