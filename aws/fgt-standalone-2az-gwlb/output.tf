output "id" {
  value = aws_instance.fgt.id
}

output "eip" {
  value = aws_eip.fgt_eip-mgmt.public_ip
}