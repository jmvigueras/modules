#------------------------------------------------------------------------------
# Create FGT cluster onramp
# - Create FGT onramp config (FGSP Active-Active)
# - Create FGT instance
# - Create FGT VPC
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

  config_fgsp        = true
  config_gwlb-geneve = true
  config_spoke       = true

  gwlbe_ip = module.gwlb.gwlbe_ips
  spoke = {
    id      = "spoke-1"
    cidr    = local.fgt_vpc_cidr
    bgp-asn = local.hub["bgp-asn_spoke"]
  }
  hubs = local.hubs

  vpc-spoke_cidr = [module.fgt_vpc.subnet_az1_cidrs["bastion"]]
}
// Create FGT
module "fgt" {
  source = "../../fgt-ha"

  prefix        = "${local.prefix}-onramp"
  region        = local.region
  instance_type = local.instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build

  fgt-active-ni_ids  = module.fgt_vpc.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_vpc.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_config.fgt_config_1
  fgt_config_2       = module.fgt_config.fgt_config_2

  fgt_ha_fgsp = true
  fgt_passive = true
}
// Create VPC FGT
module "fgt_vpc" {
  source = "../../vpc-fgt-2az"

  prefix     = "${local.prefix}-onramp"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-sec_cidr = local.fgt_vpc_cidr
}
#------------------------------------------------------------------------------
# Create TGW and VPC spokes
# - create TGW
# - Create VPC TGW spoke (associated to TGW spoke RT)
# - Create TGW connect (use GRE and dynamic routing to TGW)
# - Create test VM
#------------------------------------------------------------------------------
// Create TGW
module "tgw" {
  source = "../../tgw"

  prefix = "${local.prefix}-onramp"

  tgw_cidr    = local.tgw_cidr
  tgw_bgp-asn = local.tgw_bgp-asn
}
// Create VPC spoke attached to TGW
module "vpc_tgw-spoke" {
  count  = length(local.vpc-spoke_cidrs)
  source = "../../vpc-spoke-2az-to-tgw"

  prefix     = "${local.prefix}-onramp-tgw-spoke-${count.index + 1}"
  admin_cidr = local.admin_cidr
  admin_port = local.admin_port
  region     = local.region

  vpc-spoke_cidr        = local.vpc-spoke_cidrs[count.index]
  tgw_id                = module.tgw.tgw_id
  tgw_rt-association_id = module.tgw.rt_vpc-spoke_id
  tgw_rt-propagation_id = [module.tgw.rt_default_id, module.tgw.rt-vpc-sec-N-S_id, module.tgw.rt-vpc-sec-E-W_id]
}
// Create static route in TGW RouteTable Spoke
resource "aws_ec2_transit_gateway_route" "spoke_tgw_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-sec.id
  transit_gateway_route_table_id = module.tgw.rt_vpc-spoke_id
}
// Create VM test in spoke vpc AZ1
module "vm_spoke" {
  count  = length(local.vpc-spoke_cidrs)
  source = "../../new-instance"

  prefix  = "${local.prefix}-tgw-spoke-${count.index + 1}"
  keypair = aws_key_pair.keypair.key_name

  subnet_id       = module.vpc_tgw-spoke[count.index].subnet_az1_ids["vm"]
  security_groups = [module.vpc_tgw-spoke[count.index].nsg_ids["vm"]]
}
#------------------------------------------------------------------------------
# Create GWLB
#------------------------------------------------------------------------------
module "gwlb" {
  source = "../../gwlb"

  prefix = "${local.prefix}"

  fgt_1_ip = module.fgt_vpc.fgt-active-ni_ips["private"]
  fgt_2_ip = module.fgt_vpc.fgt-passive-ni_ips["private"]

  vpc_id     = module.fgt_vpc.vpc-sec_id
  subnet_ids = [module.fgt_vpc.subnet_az1_ids["gwlb"], module.fgt_vpc.subnet_az2_ids["gwlb"]]
}
#---------------------------------------------------------------------------
# Routes in VPC FGT:
# - Route Table for subnet TGW
# - Route Table for subnet GWLB
#---------------------------------------------------------------------------
// Create route tgw AZ1
resource "aws_route_table" "rt-tgw-az1" {
  vpc_id = module.fgt_vpc.vpc-sec_id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = module.gwlb.gwlb_endpoints[0]
  }
  tags = {
    Name = "${local.prefix}-onramp-rt-tgw-az1"
  }
}
// Create route tgw AZ2
resource "aws_route_table" "rt-tgw-az2" {
  vpc_id = module.fgt_vpc.vpc-sec_id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = module.gwlb.gwlb_endpoints[1]
  }
  tags = {
    Name = "${local.prefix}-onramp-rt-tgw-az2"
  }
}
// Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-tgw" {
  subnet_id      = module.fgt_vpc.subnet_az1_ids["tgw"]
  route_table_id = aws_route_table.rt-tgw-az1.id
}
// Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-tgw" {
  subnet_id      = module.fgt_vpc.subnet_az2_ids["tgw"]
  route_table_id = aws_route_table.rt-tgw-az2.id
}

// Route subnet gwlb
resource "aws_route_table" "rt-gwlb" {
  vpc_id = module.fgt_vpc.vpc-sec_id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = module.tgw.tgw_id
  }
  tags = {
    Name = "${local.prefix}-onramp-rt-gwlb"
  }
}
// Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-gwlb" {
  subnet_id      = module.fgt_vpc.subnet_az1_ids["gwlb"]
  route_table_id = aws_route_table.rt-gwlb.id
}
// Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-gwlb" {
  subnet_id      = module.fgt_vpc.subnet_az2_ids["gwlb"]
  route_table_id = aws_route_table.rt-gwlb.id
}
#---------------------------------------------------------------------------
# TGW attachment
#---------------------------------------------------------------------------
// Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-sec" {
  subnet_ids             = [module.fgt_vpc.subnet_az1_ids["tgw"], module.fgt_vpc.subnet_az2_ids["tgw"]]
  transit_gateway_id     = module.tgw.tgw_id
  vpc_id                 = module.fgt_vpc.vpc-sec_id
  appliance_mode_support = "enable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${local.prefix}-tgw-att-vpc-sec"
  }
}
// Create route table association
resource "aws_ec2_transit_gateway_route_table_association" "tgw-att-vpc-sec_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-sec.id
  transit_gateway_route_table_id = module.tgw.rt_default_id
}