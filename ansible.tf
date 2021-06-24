## templateからデータを作成  

data "template_file" "ansible_inventory" {
  template = file("${path.module}/template/inventory.tpl")

  vars = {
    windows_ip       = "${vsphere_virtual_machine.vm[0].default_ip_address}"
    windows_user     = "${var.template_user}"
    windows_password = "${var.template_user_password}"
  }
}


resource "null_resource" "execure_ansible" {
  count = var.prov_vm_num

  triggers = {
    cluster_instance_ids = join(",", vsphere_virtual_machine.vm.*.name)
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/"
    command     = "echo '${data.template_file.ansible_inventory.rendered}' > win_inv"
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/"
    command     = "ansible-playbook -i win_inv playbook/example.yml -vvv"
  }
}
