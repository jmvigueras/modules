##############################################################################################################
# Create FGT ACTIVE VM
##############################################################################################################

// Create and attach the Elastic Public IPs to interface public interface
resource "aws_eip" "eip-fgt_public" {
  vpc               = true
  network_interface = aws_network_interface.ni-fgt-port2.id
  tags = var.tags
}

// Create and attach the Elastic Public IPs to interface management interface
resource "aws_eip" "eip-fgt_mgmt" {
  vpc               = true
  network_interface = aws_network_interface.ni-fgt-port1.id
  tags = var.tags
}

// Create the instance Fortigate in AZ1
resource "aws_instance" "fgt" {
  ami                  = data.aws_ami_ids.fgt-ond-amis.ids[1]
  instance_type        = "c5.xlarge"
  availability_zone    = var.region["region_az1"]
  key_name             = var.key-pair_name != null ? var.key-pair_name : aws_key_pair.fgt-vpc-spoke-kp[0].key_name
  iam_instance_profile = aws_iam_instance_profile.fgt-sdn_profile.name
  user_data            = data.template_file.fgt.rendered
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.ni-fgt-port1.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.ni-fgt-port2.id
  }
  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.ni-fgt-port3.id
  }
  tags = var.tags
}

// Create user-data Fortigate in AZ1
data "template_file" "fgt" {
  template = file("${path.module}/fgt.conf")

  vars = {
    fgt_id               = "${var.tags["Name"]}-fgt"
    admin_port           = var.admin_port
    admin_cidr           = var.admin_cidr

    port1_ip             = aws_network_interface.ni-fgt-port1.private_ip
    port1_mask           = cidrnetmask(aws_subnet.subnet-az1-mgmt-ha.cidr_block)
    port1_gw             = cidrhost(aws_subnet.subnet-az1-mgmt-ha.cidr_block,1)
    port2_ip             = aws_network_interface.ni-fgt-port2.private_ip
    port2_mask           = cidrnetmask(aws_subnet.subnet-az1-public.cidr_block)
    port2_gw             = cidrhost(aws_subnet.subnet-az1-public.cidr_block,1)
    port3_ip             = aws_network_interface.ni-fgt-port3.private_ip
    port3_mask           = cidrnetmask(aws_subnet.subnet-az1-private.cidr_block)
    port3_gw             = cidrhost(aws_subnet.subnet-az1-private.cidr_block,1)

    api_key              = random_string.api_key.result
   
    local_bgp_asn        = var.hub_advpn["spoke_asn"]
    hub_bgp_asn           = var.hub_advpn["hub_asn"]
    local_bgp_id         = cidrhost(var.hub_advpn["advpn_net"],250)
    local_advpn_i-ip1    = cidrhost(var.hub_advpn["advpn_net"],250)
    hub_advpn_i-ip1      = cidrhost(var.hub_advpn["advpn_net"],254)
    hub_advpn_e-ip1      = var.hub_advpn["advpn_e-ip1"]
    local_advpn_i-net1   = cidrhost(var.hub_advpn["advpn_net"],0)
    local_advpn_i-mask1  = cidrnetmask(var.hub_advpn["advpn_net"])
    local_servers_cidr   = var.vpc-spoke_cidr
    local_advpn_psk      = var.hub_advpn_psk
   
    /*
    hub_advpn_psk        = var.externalid_token
    hub_bgp_asn          = var.vpc-golden_hub["bgp_asn"]
    hub_advpn_e-ip1      = var.vpc-golden_hub["advpn_pip"]
    hub_advpn_i-ip1      = cidrhost(var.vpc-golden_hub["advpn_net"],254)
    hub_cidr             = var.vpc-golden_cidr
    sla_hck_ip1          = var.vpc-golden_hub["sla_hck_ip"]
    */
  }
}

// Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length                 = 30
  special                = false
  numeric                = true
}

// Create new random API key to be provisioned in FortiGates.
resource "random_string" "hub_advpn_psk" {
  length                 = 30
  special                = false
  numeric                = true
}

# Get the last AMI Images from AWS MarektPlace FGT on-demand
data "aws_ami_ids" "fgt-ond-amis" {
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiGate-VM64-AWSONDEMAND*"]
  }
}