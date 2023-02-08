##############################################################################################################
# VM LINUX server
##############################################################################################################

// Server in subnet Servers
resource "aws_instance" "server" {
  ami                    = data.aws_ami.server_ami-amazon.id
  instance_type          = var.vm_size
  key_name               = var.key-pair_name != null ? var.key-pair_name : aws_key_pair.server-kp[0].key_name
  user_data              = data.template_file.data-server_user-data.rendered
  network_interface {
    device_index         = 0
    network_interface_id = var.eni-server["id"]
  }

  tags = var.tags
}

// Retrieve AMI info
data "aws_ami" "server_ami-amazon" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

// Create user-data for server
data "template_file" "data-server_user-data" {
  template = file("${path.module}/server_user-data.tpl")
  vars = {
    url = var.app_uri
  }
}

// Create key-pair if not provided
resource "aws_key_pair" "server-kp" {
  count      = var.key-pair_name != null ? 0 : 1
  key_name   = "${var.tags["Name"]}-server-kp"
  public_key = var.key-pair_rsa-public-key
}


