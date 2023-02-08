##############################################################################################################
# - NOT CHANGE - Create Network Interfaces for Fortigate
##############################################################################################################

# Create Elastic Network Interface port1 with static IP .10
resource "aws_network_interface" "ni-fgt-port1" {
  subnet_id         = aws_subnet.subnet-az1-mgmt-ha.id
  security_groups   = [aws_security_group.nsg-vpc-spoke-mgmt.id]
  private_ips       = [cidrhost(aws_subnet.subnet-az1-mgmt-ha.cidr_block, 10)]
  source_dest_check = false
  tags = var.tags
}

# Create Elastic Network Interface port2 with static IP .10
resource "aws_network_interface" "ni-fgt-port2" {
  subnet_id         = aws_subnet.subnet-az1-public.id
  security_groups   = [aws_security_group.nsg-vpc-spoke-public.id]
  private_ips       = [cidrhost(aws_subnet.subnet-az1-public.cidr_block, 10)]
  source_dest_check = false
  tags = var.tags
}

# Create Elastic Network Interface port3 with static IP .10
resource "aws_network_interface" "ni-fgt-port3" {
  subnet_id         = aws_subnet.subnet-az1-private.id
  security_groups   = [aws_security_group.nsg-vpc-spoke-private.id]
  private_ips       = [cidrhost(aws_subnet.subnet-az1-private.cidr_block, 10)]
  source_dest_check = false
  tags = var.tags
}

##############################################################################################################
# - NOT CHANGE - Create Network Interfaces for Server
##############################################################################################################

# Create Elastic Network Interface Server with static IP .10
resource "aws_network_interface" "ni-server-port1" {
  subnet_id         = aws_subnet.subnet-az1-servers.id
  security_groups   = [aws_security_group.nsg-vpc-spoke-servers.id]
  private_ips       = [cidrhost(aws_subnet.subnet-az1-servers.cidr_block, 10)]
  source_dest_check = false
  tags = var.tags
}
