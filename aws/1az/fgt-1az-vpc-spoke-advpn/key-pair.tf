#########################################################################
# - NOT CHANGE - 
# Create key pair for Fortigate instance
#########################################################################

resource "aws_key_pair" "fgt-vpc-spoke-kp" {
  count      = var.key-pair_name != null ? 0 : 1
  key_name   = "${var.tags["Name"]}-fgt-vpc-spoke-kp"
  public_key = var.key-pair_rsa-public-key
}

