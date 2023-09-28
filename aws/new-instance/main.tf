#-----------------------------------------------------------------------------------------------------
# VM LINUX for testing
#-----------------------------------------------------------------------------------------------------
// Create Amazon Linux EC2 Instance (default)
resource "aws_instance" "vm" {
  count                       = var.iam_profile != null ? 0 : 1
  ami                         = var.linux_os == "ubuntu" ? data.aws_ami.ami_ubuntu.id : data.aws_ami.ami_amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = var.keypair
  user_data                   = var.user_data == null ? file("${path.module}/templates/user-data.sh") : var.user_data
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
    Name    = "${var.prefix}-vm-${var.suffix}"
    Project = var.prefix
  }
}
// Create Amazon Linux EC2 Instance with a provided IAM profile
resource "aws_instance" "vm_iam_profile" {
  count                       = var.iam_profile != null ? 1 : 0
  ami                         = data.aws_ami.ami_ubuntu.id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_profile
  key_name                    = var.keypair
  user_data                   = var.user_data == null ? file("${path.module}/templates/user-data.sh") : var.user_data
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
    Name    = "${var.prefix}-vm-${var.suffix}"
    Project = var.prefix
  }
}

// Retrieve AMI info
data "aws_ami" "ami_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Amazon Linux 2 AMI
data "aws_ami" "ami_amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


