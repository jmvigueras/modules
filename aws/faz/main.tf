# Create and attach the eip to the units
resource "aws_eip" "faz_eip_public" {
  vpc               = true
  network_interface = aws_network_interface.ni-faz-public.id
  tags = {
    Name = "${var.prefix}-faz_eip_public"
  }
}
// Create NI public
resource "aws_network_interface" "ni-faz-public" {
  subnet_id         = var.subnet_ids["public"]
  security_groups   = var.nsg_ids["public"]
  private_ips       = [local.ni_ips["public"]]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-faz-public"
  }
}
// Create NI private
resource "aws_network_interface" "ni-faz-private" {
  subnet_id         = var.subnet_ids["private"]
  security_groups   = var.nsg_ids["private"]
  private_ips       = [local.ni_ips["private"]]
  source_dest_check = false
  tags = {
    Name = "${var.prefix}-ni-faz-private"
  }
}

# Create the instance FGT AZ1 Active
resource "aws_instance" "faz" {
  ami               = var.license_type == "byol" ? data.aws_ami_ids.faz_amis_byol.ids[0] : var.faz_ami != null ? var.faz_ami : data.aws_ami_ids.faz_amis_payg.ids[0]
  instance_type     = var.instance_type
  availability_zone = var.region["az1"]
  key_name          = var.keypair
  //iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  user_data = data.template_file.faz_config.rendered
  network_interface {
    device_index         = 0
    network_interface_id = local.ni_ids[var.faz_ni_0]
  }
  network_interface {
    device_index         = 1
    network_interface_id = local.ni_ids[var.faz_ni_1]
  }
  tags = {
    Name = "${var.prefix}-faz"
  }
}

data "template_file" "faz_config" {
  template = file("${path.module}/templates/faz.conf")
  vars = {
    faz_id           = "${var.prefix}-faz"
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
    faz_extra-config = var.faz_extra-config
  }
}

# Get the last AMI Images from AWS MarektPlace FGT PAYG
data "aws_ami_ids" "faz_amis_payg" {
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiAnalyzer-VM64-AWSONDEMAND ${var.faz_build}*"]
  }
}

data "aws_ami_ids" "faz_amis_byol" {
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["FortiAnalyzer-VM64-AWS ${var.faz_build}*"]
  }
}