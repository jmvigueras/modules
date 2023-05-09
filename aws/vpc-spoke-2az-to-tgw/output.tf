output "subnet_az1_cidrs" {
  value = {
    vm   = aws_subnet.subnet-vpc-az1-vm.cidr_block
    tgw  = aws_subnet.subnet-vpc-az1-tgw.cidr_block
    gwlb = aws_subnet.subnet-vpc-az1-gwlb.cidr_block
  }
}

output "subnet_az2_cidrs" {
  value = {
    vm   = aws_subnet.subnet-vpc-az2-vm.cidr_block
    tgw  = aws_subnet.subnet-vpc-az2-tgw.cidr_block
    gwlb = aws_subnet.subnet-vpc-az2-gwlb.cidr_block
  }
}

output "subnet_az1_ids" {
  value = {
    vm   = aws_subnet.subnet-vpc-az1-vm.id
    tgw  = aws_subnet.subnet-vpc-az1-tgw.id
    gwlb = aws_subnet.subnet-vpc-az1-gwlb.id
  }
}

output "subnet_az2_ids" {
  value = {
    vm   = aws_subnet.subnet-vpc-az2-vm.id
    tgw  = aws_subnet.subnet-vpc-az2-tgw.id
    gwlb = aws_subnet.subnet-vpc-az2-gwlb.id
  }
}

output "nsg_ids" {
  value = {
    vm = aws_security_group.nsg-vpc-vm.id
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_igw_id" {
  value = aws_internet_gateway.igw-vpc.id
}

output "vpc_tgw-att_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc.id
}

/*
output "az1-vm-ni_id" {
  value = aws_network_interface.ni-vm-spoke-az1.id
}

output "az1-vm-ni_ip" {
  value = aws_network_interface.ni-vm-spoke-az1.private_ip
}

output "az2-vm-ni_id" {
  value = aws_network_interface.ni-vm-spoke-az2.id
}

output "az2-vm-ni_ip" {
  value = aws_network_interface.ni-vm-spoke-az2.private_ip
}
*/