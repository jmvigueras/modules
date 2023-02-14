output "faz_id" {
  value = aws_instance.faz.id
}

output "faz_eip_public" {
  value = aws_eip.faz_eip_public.public_ip
}