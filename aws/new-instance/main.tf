#-----------------------------------------------------------------------------------------------------
# VM LINUX for testing
#-----------------------------------------------------------------------------------------------------
// Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]  
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

// Create Amazon Linux EC2 Instance
resource "aws_instance" "vm" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.vm_size
  key_name                    = var.keypair
  user_data                   = file("${path.module}/templates/aws-user-data.sh")
  subnet_id                   = var.subnet_id
  security_groups             = var.security_groups
  associate_public_ip_address = var.public_ip
   
  root_block_device {
    volume_size           = var.disk_size
    volume_type           = var.disk_type
    delete_on_termination = true
    encrypted             = true
  }
  tags = {
    Name    = "${var.prefix}-vm"
    Project = var.prefix
  }
}

/*
// Create public IP for instance
resource "aws_eip" "vm_eip" {
  depends_on        = [aws_instance.vm]
  vpc               = true
  network_interface = var.ni_id
  tags = {
    Name    = "${var.prefix}-eip-vm"
    Project = var.prefix
  }
}
// Create instance
resource "aws_instance" "vm" {
  ami           = data.aws_ami.vm_ami_ubuntu.id
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
// Retrieve AMI info
data "aws_ami" "vm_ami_ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
*/




