# ------------------------------------------------------------------
# Create EIPs
# ------------------------------------------------------------------
# Create and attach the eip to the units
resource "aws_eip" "fgt_active_eip_public" {
  vpc                       = true
  network_interface         = aws_network_interface.ni-active-public.id
  associate_with_private_ip = local.fgt_ni_public_ip_float
  tags = {
    Name = "${var.prefix}-fgt_active_eip_public"
  }
}

resource "aws_eip" "fgt_active_eip_mgmt" {
  vpc               = true
  network_interface = aws_network_interface.ni-active-mgmt.id
  tags = {
    Name = "${var.prefix}-fgt_active_eip_mgmt"
  }
}

# Create and attach the eip to the units
resource "aws_eip" "fgt_passive_eip_mgmt" {
  vpc               = true
  network_interface = aws_network_interface.ni-passive-mgmt.id
  tags = {
    Name = "${var.prefix}-fgt_passive_eip_mgmt"
  }
}

# Create and attach the eip to the units
resource "aws_eip" "fgt_passive_eip_public" {
  vpc               = true
  network_interface = aws_network_interface.ni-passive-public.id
  tags = {
    Name = "${var.prefix}-fgt_passive_eip_public"
  }
}

# ------------------------------------------------------------------
# Create all the eni interfaces FGT active
# ------------------------------------------------------------------
resource "aws_network_interface" "ni-active-mgmt" {
  subnet_id         = aws_subnet.subnet-az1-mgmt-ha.id
  security_groups   = [aws_security_group.nsg-vpc-sec-mgmt.id, aws_security_group.nsg-vpc-sec-ha.id]
  private_ips       = local.fgt-1_ni_mgmt_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-active-mgmt"
  }
}

resource "aws_network_interface" "ni-active-public" {
  subnet_id         = aws_subnet.subnet-az1-public.id
  security_groups   = [aws_security_group.nsg-vpc-sec-public.id]
  private_ips       = local.fgt-1_ni_public_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-active-public"
  }
}

resource "aws_network_interface" "ni-active-private" {
  subnet_id         = aws_subnet.subnet-az1-private.id
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
  subnet_id         = aws_subnet.subnet-az1-mgmt-ha.id
  security_groups   = [aws_security_group.nsg-vpc-sec-mgmt.id, aws_security_group.nsg-vpc-sec-ha.id]
  private_ips       = local.fgt-2_ni_mgmt_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-passive-mgmt"
  }
}

resource "aws_network_interface" "ni-passive-public" {
  subnet_id         = aws_subnet.subnet-az1-public.id
  security_groups   = [aws_security_group.nsg-vpc-sec-public.id]
  private_ips       = local.fgt-2_ni_public_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-passive-public"
  }
}

resource "aws_network_interface" "ni-passive-private" {
  subnet_id         = aws_subnet.subnet-az1-private.id
  security_groups   = [aws_security_group.nsg-vpc-sec-private.id]
  private_ips       = local.fgt-2_ni_private_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-passive-private"
  }
}

# ------------------------------------------------------------------
# Create all the eni interfaces Bastion
# ------------------------------------------------------------------
resource "aws_network_interface" "ni-bastion-az1" {
  subnet_id         = aws_subnet.subnet-az1-bastion.id
  security_groups   = [aws_security_group.nsg-vpc-sec-bastion.id]
  private_ips       = local.bastion_az1_ni_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-bastion-az1"
  }
}

# ------------------------------------------------------------------
# Create all the eni interfaces FAZ
# ------------------------------------------------------------------
resource "aws_network_interface" "ni-faz-public" {
  subnet_id         = aws_subnet.subnet-az1-public.id
  security_groups   = [aws_security_group.nsg-vpc-sec-allow-all.id]
  private_ips       = local.faz_az1_ni_public_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-faz-public"
  }
}

resource "aws_network_interface" "ni-faz-private" {
  subnet_id         = aws_subnet.subnet-az1-bastion.id
  security_groups   = [aws_security_group.nsg-vpc-sec-allow-all.id]
  private_ips       = local.faz_az1_ni_private_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-faz-private"
  }
}

# ------------------------------------------------------------------
# Create all the eni interfaces FMG
# ------------------------------------------------------------------
resource "aws_network_interface" "ni-fmg-public" {
  subnet_id         = aws_subnet.subnet-az1-public.id
  security_groups   = [aws_security_group.nsg-vpc-sec-allow-all.id]
  private_ips       = local.fmg_az1_ni_public_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-fmg-public"
  }
}

resource "aws_network_interface" "ni-fmg-private" {
  subnet_id         = aws_subnet.subnet-az1-bastion.id
  security_groups   = [aws_security_group.nsg-vpc-sec-allow-all.id]
  private_ips       = local.fmg_az1_ni_private_ips
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-fmg-private"
  }
}