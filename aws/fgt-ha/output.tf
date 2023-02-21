output "fgt_active_id" {
  value = aws_instance.fgt_active.id
}

output "fgt_passive_id" {
  value = aws_instance.fgt_passive.*.id
}