# Create and attach the eip to the units
resource "aws_eip" "fmg_eip_public" {
  //domain           = "vpc"
  vpc               = true
  network_interface = aws_network_interface.ni-fmg-public.id
  tags = {
    Name = "${var.prefix}-fmg_eip_public"
  }
}
// Create NI public
resource "aws_network_interface" "ni-fmg-public" {
  subnet_id         = var.subnet_ids["public"]
  security_groups   = var.nsg_ids["public"]
  private_ips       = [local.ni_ips["public"]]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-fmg-public"
  }
}
// Create NI private
resource "aws_network_interface" "ni-fmg-private" {
  subnet_id         = var.subnet_ids["private"]
  security_groups   = var.nsg_ids["private"]
  private_ips       = [local.ni_ips["private"]]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-fmg-private"
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
    network_interface_id = local.ni_ids[var.fmg_ni_0]
  }
  network_interface {
    device_index         = 1
    network_interface_id = local.ni_ids[var.fmg_ni_1]
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
    public_ip        = local.ni_ips["public"]
    public_mask      = cidrnetmask(var.subnet_cidrs["public"])
    public_gw        = cidrhost(var.subnet_cidrs["public"], 1)
    private_port     = var.private_port
    private_ip       = local.ni_ips["private"]
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