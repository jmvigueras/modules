# ------------------------------------------------------------------
# Create all the eni interfaces FGT active
# ------------------------------------------------------------------
resource "aws_network_interface" "ni-active-mgmt" {
  subnet_id         = var.subnet_az1_ids["mgmt"]
  security_groups   = [aws_security_group.nsg-vpc-sec-mgmt.id, aws_security_group.nsg-vpc-sec-ha.id]
  private_ips       = local.fgt-1_ni_mgmt_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-active-mgmt"
  }
}

resource "aws_network_interface" "ni-active-public" {
  subnet_id         = var.subnet_az1_ids["public"]
  security_groups   = [aws_security_group.nsg-vpc-sec-public.id]
  private_ips       = local.fgt-1_ni_public_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-active-public"
  }
}

resource "aws_network_interface" "ni-active-private" {
  subnet_id         = var.subnet_az1_ids["private"]
  security_groups   = [aws_security_group.nsg-vpc-sec-private.id]
  private_ips       = local.fgt-1_ni_private_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-active-private"
  }
}

# ------------------------------------------------------------------
# Create all the eni interfaces FGT passive
# ------------------------------------------------------------------
resource "aws_network_interface" "ni-passive-mgmt" {
  subnet_id         = var.subnet_az2_ids["mgmt"]
  security_groups   = [aws_security_group.nsg-vpc-sec-mgmt.id, aws_security_group.nsg-vpc-sec-ha.id]
  private_ips       = local.fgt-2_ni_mgmt_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-passive-mgmt"
  }
}

resource "aws_network_interface" "ni-passive-public" {
  subnet_id         = var.subnet_az2_ids["public"]
  security_groups   = [aws_security_group.nsg-vpc-sec-public.id]
  private_ips       = local.fgt-2_ni_public_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-passive-public"
  }
}

resource "aws_network_interface" "ni-passive-private" {
  subnet_id         = var.subnet_az2_ids["private"]
  security_groups   = [aws_security_group.nsg-vpc-sec-private.id]
  private_ips       = local.fgt-2_ni_private_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-passive-private"
  }
}
