##############################################################################################################
# FORTIGATES VM
##############################################################################################################

// Creat public IP for master member
resource "aws_eip" "fgt_eip-mgmt" {
  vpc               = true
  network_interface = var.fgt-active-ni_ids["mgmt"]
  tags = {
    Name = "${var.prefix}-eip-master-mgmt"
  }
}

# Create the instance FGT AZ1 Active
resource "aws_instance" "fgt" {
  ami                  = var.fgt-ami
  instance_type        = var.instance_type
  availability_zone    = var.region["az1"]
  key_name             = var.keypair
  iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  user_data            = data.template_file.fgt-master.rendered
  network_interface {
    device_index         = 0
    network_interface_id = var.fgt-active-ni_ids["private"]
  }
  network_interface {
    device_index         = 1
    network_interface_id = var.fgt-active-ni_ids["mgmt"]
  }
  tags = {
    Name = "${var.prefix}-fgt-master"
  }
}

data "template_file" "fgt-master" {
  template = file("${path.module}/templates/fgt-fgsp-master.conf")

  vars = {
    fgt_id         = "${var.prefix}-fgt-master"
    admin_port     = var.admin_port
    admin_cidr     = var.admin_cidr
    rsa-public-key = var.rsa-public-key
    api_key        = var.api_key

    private_port = "port1"
    private_ip   = var.fgt-active-ni_ips["private"]
    private_mask = cidrnetmask(var.subnet_az1_cidrs["private"])
    private_gw   = cidrhost(var.subnet_az1_cidrs["private"], 1)
    mgmt_port    = "port2"
    mgmt_ip      = var.fgt-active-ni_ips["mgmt"]
    mgmt_mask    = cidrnetmask(var.subnet_az1_cidrs["mgmt"])
    mgmt_gw      = cidrhost(var.subnet_az1_cidrs["mgmt"], 1)

    gwlb_ip1 = var.gwlb_ip1
    gwlb_ip2 = var.gwlb_ip2

    backend-probe_port = var.backend-probe_port

    subnet-az1-gwlb = var.subnet_az1_cidrs["gwlb"]
    subnet-az2-gwlb = var.subnet_az2_cidrs["gwlb"]
  }
}

