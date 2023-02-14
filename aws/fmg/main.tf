# Create and attach the eip to the units
resource "aws_eip" "fmg_eip_public" {
  vpc               = true
  network_interface = var.fmg_ni_ids["public"]
  tags = {
    Name = "${var.prefix}-fmg_eip_public"
  }
}

# Create the instance FGT AZ1 Active
resource "aws_instance" "fmg" {
  ami               = var.license_type == "byol" ? data.aws_ami_ids.fmg_amis_byol.ids[0] : var.fmg_ami != null ? var.fmg_ami : data.aws_ami_ids.fmg_amis_payg.ids[0]
  instance_type     = var.instance_type
  availability_zone = var.region["az1"]
  key_name          = var.keypair
  //iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  user_data = data.template_file.fmg_config.rendered
  network_interface {
    device_index         = 0
    network_interface_id = var.fmg_ni_ids[var.fmg_ni_0]
  }
  network_interface {
    device_index         = 1
    network_interface_id = var.fmg_ni_ids[var.fmg_ni_1]
  }
  tags = {
    Name = "${var.prefix}-fmg"
  }
}

data "template_file" "fmg_config" {
  template = file("${path.module}/templates/fmg.conf")
  vars = {
    fmg_id           = "${var.prefix}-fmg"
    type             = var.license_type
    license_file     = var.license_file
    admin_username   = var.admin_username
    rsa-public-key   = trimspace(var.rsa-public-key)
    public_port      = var.public_port
    public_ip        = var.fmg_ni_ips["public"]
    public_mask      = cidrnetmask(var.subnet_cidrs["public"])
    public_gw        = cidrhost(var.subnet_cidrs["public"], 1)
    private_port     = var.private_port
    private_ip       = var.fmg_ni_ips["private"]
    private_mask     = cidrnetmask(var.subnet_cidrs["private"])
    private_gw       = cidrhost(var.subnet_cidrs["private"], 1)
    fmg_extra-config = var.fmg_extra-config
  }
}

# Get the last AMI Images from AWS MarektPlace FGT PAYG
data "aws_ami_ids" "fmg_amis_payg" {
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiManager VM64-AWSONDEMAND ${var.fmg_build}*"]
  }
}

data "aws_ami_ids" "fmg_amis_byol" {
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiManager VM64-AWS ${var.fmg_build}*"]
  }
}