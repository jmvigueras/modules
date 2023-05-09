# Security Groups
## Need to create 4 of them as our Security Groups are linked to a VPC

resource "aws_security_group" "nsg-vpc-vm" {
  name        = "${var.prefix}-nsg-vpc-vm"
  description = "Allow SSH and ICMP traffic"
  vpc_id      = aws_vpc.vpc-spoke.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${var.admin_cidr}", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["${var.admin_cidr}", "172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["${var.admin_cidr}", "172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-nsg-vm"
  }
}

resource "aws_security_group" "nsg-vpc-gwlb" {
  name        = "${var.prefix}-nsg-vpc-gwlb"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc-spoke.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-nsg-gwlb"
  }
}
