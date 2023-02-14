output "fmg_id" {
  value = aws_instance.fmg.id
}

output "fmg_eip_public" {
  value = aws_eip.fmg_eip_public.public_ip
}