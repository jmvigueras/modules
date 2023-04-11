#-------------------------------------------------------------------------------------------------------------
# VPC SPOKE Routes
# - TGW RT
# - TGW attachment
# - TGW Route Table association
#-------------------------------------------------------------------------------------------------------------
# TableRoute to TGW
resource "aws_route_table" "rt-spoke-to-tgw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vpc.id
  }
  route {
    cidr_block           = "172.16.0.0/12"
    transit_gateway_id = var.tgw_id
  }
  route {
    cidr_block           = "192.168.0.0/16"
    transit_gateway_id = var.tgw_id
  }
  route {
    cidr_block           = "10.0.0.0/8"
    transit_gateway_id = var.tgw_id
  }
  tags = {
    Name = "${var.prefix}-rt-vm"
  }
}

# Route tables associations
# - Associate RT to TGW if provided
resource "aws_route_table_association" "ra-subnet-spoke-az1-vm-tgw" {
  subnet_id      = aws_subnet.subnet-vpc-az1-vm.id
  route_table_id = aws_route_table.rt-spoke-to-tgw.id
}
resource "aws_route_table_association" "ra-subnet-spoke-az2-vm-tgw" {
  subnet_id      = aws_subnet.subnet-vpc-az2-vm.id
  route_table_id = aws_route_table.rt-spoke-to-tgw.id
}

# Attachment to TGW
# - Create attachment if TGW if provided
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc" {
  subnet_ids         = [aws_subnet.subnet-vpc-az1-tgw.id, aws_subnet.subnet-vpc-az2-tgw.id]
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.vpc.id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${var.prefix}-tgw-att-vpc"
  }
}
# Create route table association
resource "aws_ec2_transit_gateway_route_table_association" "tgw-att-vpc_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc.id
  transit_gateway_route_table_id = var.tgw_rt-association_id
}
# Create route propagation if route table id provided
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-att-vpc_propagation" {
  count                          = length(var.tgw_rt-propagation_id)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc.id
  transit_gateway_route_table_id = var.tgw_rt-propagation_id[count.index]
}


