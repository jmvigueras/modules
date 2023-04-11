/*
# Create all the eni interfaces for test VM
resource "aws_network_interface" "ni-vm-az1" {
  subnet_id         = aws_subnet.subnet-vpc-az1-vm.id
  security_groups   = [aws_security_group.nsg-vpc-vm.id]
  private_ips       = [cidrhost(aws_subnet.subnet-vpc-az1-vm.cidr_block, 10)]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-vm-az1"
  }
}

resource "aws_network_interface" "ni-vm-az2" {
  subnet_id         = aws_subnet.subnet-vpc-az2-vm.id
  security_groups   = [aws_security_group.nsg-vpc-vm.id]
  private_ips       = [cidrhost(aws_subnet.subnet-vpc-az2-vm.cidr_block, 10)]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-vm-az2"
  }
}
*/