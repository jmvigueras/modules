#-----------------------------------------------------------------------------------------------------
# VM LINUX for testing
#-----------------------------------------------------------------------------------------------------

## Retrieve AMI info
data "aws_ami" "vm_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// Creat public IP for instance
resource "aws_eip" "vm_eip" {
  depends_on        = [aws_instance.vm]
  vpc               = true
  network_interface = var.ni_id
  tags = {
    Name    = "${var.prefix}-eip-vm"
    Project = var.prefix
  }
}

# test device in spoke1
resource "aws_instance" "vm" {
  ami           = data.aws_ami.vm_ami.id
  instance_type = var.vm_size
  key_name      = var.keypair

  network_interface {
    device_index         = 0
    network_interface_id = var.ni_id
  }

  tags = {
    Name    = "${var.prefix}-vm"
    Project = var.prefix
  }
}
