output "id" {
  value = aws_instance.faz.id
}

output "ni_ips" {
  value = local.ni_ips
}

output "eip_public" {
  value = aws_eip.faz_eip_public.public_ip
}