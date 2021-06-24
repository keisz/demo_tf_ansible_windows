#Resource
resource "vsphere_virtual_machine" "vm" {
  count            = var.prov_vm_num
  name             = "${var.prov_vmname_prefix}${format("%03d", count.index + 1)}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  #Resource for VM Specs
  num_cpus                = var.prov_cpu_num
  memory                  = var.prov_mem_num
  guest_id                = data.vsphere_virtual_machine.template.guest_id
  firmware                = var.prov_firmware
  efi_secure_boot_enabled = "true"

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network_1.id
    adapter_type = "vmxnet3"
  }

  #Resource for Disks
  disk {
    label            = "disk1"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  wait_for_guest_net_timeout = 10
  ignored_guest_ips          = ["10.42.0.0/24"]


  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      timeout = 20
      windows_options {
        computer_name         = "${var.prov_vmname_prefix}${format("%03d", count.index + 1)}"
        admin_password        = var.template_user_password
        join_domain           = var.pram_domain_name
        domain_admin_user     = var.domain_admin_user
        domain_admin_password = var.domain_admin_password
        auto_logon            = "true"
        auto_logon_count      = 1

        run_once_command_list = [
          "cmd.exe /C Powershell.exe Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile c:\\winrm.ps1",
          "cmd.exe /C Powershell.exe -ExecutionPolicy Bypass -File c:\\winrm.ps1",
        ]
      }

      network_interface {
        ipv4_address    = "${var.pram_ipv4_class}${count.index + var.pram_ipv4_host}"
        ipv4_netmask    = var.pram_ipv4_subnet
        dns_server_list = [var.pram_dns_server]
        #dns_domain = var.pram_domain_name
      }

      ipv4_gateway = var.pram_ipv4_gateway
    }
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/"
    command     = "sleep 60"
  }
}
