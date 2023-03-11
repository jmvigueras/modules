# Create the IAM role/profile for the API Call
resource "aws_iam_instance_profile" "fgt-apicall-profile" {
  name = "${var.prefix}-fgt-apicall-profile"
  role = aws_iam_role.fgt-apicall-role.name
}

resource "aws_iam_role" "fgt-apicall-role" {
  name = "${var.prefix}-fgt-apicall-role"

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

resource "aws_iam_policy" "fgt-apicall-policy" {
  name        = "${var.prefix}-fgt-apicall-policy"
  path        = "/"
  description = "Policies for the FGT api-call Role"

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

resource "aws_iam_policy_attachment" "fgt-apicall-attach" {
  name       = "${var.prefix}-fgt-apicall-attachment"
  roles      = [aws_iam_role.fgt-apicall-role.name]
  policy_arn = aws_iam_policy.fgt-apicall-policy.arn
}