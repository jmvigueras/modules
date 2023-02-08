#########################################################################
# Create key pair for Fortigate instance in case it is not provide one
#########################################################################

resource "aws_key_pair" "fgt-vpc-hub-kp" {
  count      = var.key-pair_name != null ? 0 : 1
  key_name   = "${var.tags["Name"]}-fgt-vpc-hub-kp"
  public_key = var.key-pair_rsa-public-key
}
