#########################################################################
# - NOT CHANGE - 
# Create role associate to Fortigate instance for the SDN connector API Call
#########################################################################

# Create role
resource "aws_iam_role" "fgt-sdn_role" {
  name = "${var.tags["Name"]}-fgt-sdn_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Create instance profile
resource "aws_iam_instance_profile" "fgt-sdn_profile" {
  name = "${var.tags["Name"]}-fgt-sdn_profile"
  role = aws_iam_role.fgt-sdn_role.name
}

# Create policy with necessary permission for SDN connector (prepared for cluster HA)
resource "aws_iam_policy" "fgt-sdn_policy" {
  name        = "${var.tags["Name"]}-fgt-sdn_policy"
  path        = "/"
  description = "Policies for the FGT APICall Role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Action": 
            [
              "ec2:Describe*",
              "ec2:AssociateAddress",
              "ec2:AssignPrivateIpAddresses",
              "ec2:UnassignPrivateIpAddresses",
              "ec2:ReplaceRoute",
              "eks:ListClusters"
            ],
            "Resource": "*"
        }
      ]
}
EOF
}

resource "aws_iam_policy_attachment" "fgt-sdn_attach" {
  name       = "${var.tags["Name"]}-fgt-sdn_attachment"
  roles      = [aws_iam_role.fgt-sdn_role.name]
  policy_arn = aws_iam_policy.fgt-sdn_policy.arn
}