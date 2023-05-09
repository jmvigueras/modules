output "vm" {
  value = {
    vm_id      = var.iam_profile == null ? aws_instance.vm.*.id[0] : aws_instance.vm_iam_profile.*.id[0]
    adminuser  = "ubuntu"
    private_ip = var.iam_profile == null ? aws_instance.vm.*.private_ip[0] : aws_instance.vm_iam_profile.*.private_ip[0]
    public_ip  = var.public_ip ? var.iam_profile == null ? aws_instance.vm.*.public_ip[0] : aws_instance.vm_iam_profile.*.public_ip[0] : ""
  }
}