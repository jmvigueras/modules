#---------------------------------------------------------------------------
# Route subnet mgmt (FGT)
#---------------------------------------------------------------------------
# Create route MGMT interfaces
resource "aws_route_table" "rt-mgmt-ha" {
  vpc_id = aws_vpc.vpc-sec.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vpc-sec.id
  }
  tags = {
    Name = "${var.prefix}-rt-mgmt-ha"
  }
}
# Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-mgmt-ha" {
  subnet_id      = aws_subnet.subnet-az1-mgmt-ha.id
  route_table_id = aws_route_table.rt-mgmt-ha.id
}
# Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-mgmt-ha" {
  subnet_id      = aws_subnet.subnet-az2-mgmt-ha.id
  route_table_id = aws_route_table.rt-mgmt-ha.id
}

#---------------------------------------------------------------------------
# Route subnet public (FGT)
#---------------------------------------------------------------------------
# Route subnet public
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc-sec.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vpc-sec.id
  }
  tags = {
    Name = "${var.prefix}-rt-public"
  }
}
# Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-public" {
  subnet_id      = aws_subnet.subnet-az1-public.id
  route_table_id = aws_route_table.rt-public.id
}
# Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-public" {
  subnet_id      = aws_subnet.subnet-az2-public.id
  route_table_id = aws_route_table.rt-public.id
}

#---------------------------------------------------------------------------
# Route subnet private (bastion)
#---------------------------------------------------------------------------
# Route subnet private bastion
resource "aws_route_table" "rt-bastion" {
  vpc_id = aws_vpc.vpc-sec.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vpc-sec.id
  }
  route {
    cidr_block           = "172.16.0.0/12"
    network_interface_id = aws_network_interface.ni-active-private.id
  }
  route {
    cidr_block           = "192.168.0.0/16"
    network_interface_id = aws_network_interface.ni-active-private.id
  }
  route {
    cidr_block           = "10.0.0.0/8"
    network_interface_id = aws_network_interface.ni-active-private.id
  }
  tags = {
    Name = "${var.prefix}-rt-bastion"
  }
}
# Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-bastion" {
  subnet_id      = aws_subnet.subnet-az1-bastion.id
  route_table_id = aws_route_table.rt-bastion.id
}
# Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-bastion" {
  subnet_id      = aws_subnet.subnet-az2-bastion.id
  route_table_id = aws_route_table.rt-bastion.id
}

#---------------------------------------------------------------------------
# Route subnet private (FGT)
# - Create TGW attachment
# - Associate to RT
# - Propagate to RT
#---------------------------------------------------------------------------
# Attachment to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-sec" {
  subnet_ids             = [aws_subnet.subnet-az1-tgw.id, aws_subnet.subnet-az2-tgw.id]
  transit_gateway_id     = var.tgw_id
  vpc_id                 = aws_vpc.vpc-sec.id
  appliance_mode_support = "enable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${var.prefix}-tgw-att-vpc-sec"
  }
}
# Create route table association
resource "aws_ec2_transit_gateway_route_table_association" "tgw-att-vpc-sec_association" {
//  count                          = var.tgw_rt-association_id == null ? 0 : 1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-sec.id
  transit_gateway_route_table_id = var.tgw_rt-association_id
}
# Create route propagation if route table id provided
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-att-vpc-sec_propagation" {
//  count                          = var.tgw_rt-propagation_id == null ? 0 : 1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-sec.id
  transit_gateway_route_table_id = var.tgw_rt-propagation_id
}
# Create RouteTable private to TGW
resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.vpc-sec.id
  route {
    cidr_block         = "172.16.0.0/12"
    transit_gateway_id = var.tgw_id
  }
  route {
    cidr_block         = "192.168.0.0/16"
    transit_gateway_id = var.tgw_id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = var.tgw_id
  }
  tags = {
    Name = "${var.prefix}-rt-private"
  }
}
# Associate to private subnet
resource "aws_route_table_association" "ra-subnet-az1-private" {
  subnet_id      = aws_subnet.subnet-az1-private.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "ra-subnet-az2-private" {
  subnet_id      = aws_subnet.subnet-az2-private.id
  route_table_id = aws_route_table.rt-private.id
}

#---------------------------------------------------------------------------
# Route subnet TGW 
# - Create GWLB endpoints
# - Create route TGW endpoint to GWLB endopint
#---------------------------------------------------------------------------
# Create VPC endpoints GWLB
resource "aws_vpc_endpoint" "gwlbe_az1" {
  //  count             = var.gwlb_service-name != null ? 1 : 0
  service_name      = var.gwlb_service-name
  subnet_ids        = [aws_subnet.subnet-az1-gwlb.id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpc-sec.id
}
resource "aws_vpc_endpoint" "gwlbe_az2" {
  //  count             = var.gwlb_service-name != null ? 1 : 0
  service_name      = var.gwlb_service-name
  subnet_ids        = [aws_subnet.subnet-az2-gwlb.id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.vpc-sec.id
}
# Create route tgw AZ1
resource "aws_route_table" "rt-tgw-az1" {
  vpc_id = aws_vpc.vpc-sec.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.gwlbe_az1.id
  }

  tags = {
    Name = "${var.prefix}-rt-tgw-az1"
  }
}
# Create route tgw AZ2
resource "aws_route_table" "rt-tgw-az2" {
  vpc_id = aws_vpc.vpc-sec.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_vpc_endpoint.gwlbe_az2.id
  }
  tags = {
    Name = "${var.prefix}-rt-tgw-az2"
  }
}
# Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-tgw" {
  subnet_id      = aws_subnet.subnet-az1-tgw.id
  route_table_id = aws_route_table.rt-tgw-az1.id
}
# Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-tgw" {
  subnet_id      = aws_subnet.subnet-az2-tgw.id
  route_table_id = aws_route_table.rt-tgw-az2.id
}

#---------------------------------------------------------------------------
# Route subnet GWLB
#---------------------------------------------------------------------------
# Route subnet gwlb
resource "aws_route_table" "rt-gwlb" {
  vpc_id = aws_vpc.vpc-sec.id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }
  tags = {
    Name = "${var.prefix}-rt-gwlb"
  }
}
# Route table association AZ1
resource "aws_route_table_association" "ra-subnet-az1-gwlb" {
  subnet_id      = aws_subnet.subnet-az1-gwlb.id
  route_table_id = aws_route_table.rt-gwlb.id
}
# Route table association AZ2
resource "aws_route_table_association" "ra-subnet-az2-gwlb" {
  subnet_id      = aws_subnet.subnet-az2-gwlb.id
  route_table_id = aws_route_table.rt-gwlb.id
}



