output "id" {
  value = aws_instance.fmg.id
}

output "ni_ips" {
  value = local.ni_ips
}

output "eip_public" {
  value = aws_eip.fmg_eip_public.public_ip
}