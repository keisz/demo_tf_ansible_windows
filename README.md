# Terraformで展開したOSに対してAnsibleを実行（Ansibleの設定をTerraformで生成)  
[Terraform](../terraform_example/sysprepimage/README.md)を使ったでデプロイしたOSに、Terraform上から[Ansible](../ansible_example/README.md)を実行します。  

ここでは、[ansible_example](../ansible_example/README.md)のInventoryファイルをTerraform上で生成します。    
よって、デプロイしたOSに対してAnsibleが実行されます。  

**現状1台のデプロイにしか対応していません**

## Terraformはどこまで実行するか？  

- Windows OSをデプロイ
- WinRMを構成
- Ansibleコマンド(ansible-playbook)を実行

### WinRMのサービス開始  
TerraformでOSをデプロイしたあとにAnsibleが実行されますが、その際にWinRMのサービスが実行されていないため、Ansibleの実行に失敗するケースがあります。
これを回避するため、OSデプロイ後に60秒間Sleepの処理をいれています。
この値は環境に合わせて変更可能です。  

## main.tfの変更点  
下記が追加されています。
```
  provisioner "local-exec" {
    working_dir = "${path.module}/"
    command = "sleep 60"
  }
```

## ansible.tf  
TerraformからAnsibleを実行、実行のためのファイル生成は [ansible.tf](ansible.tf)に記述しています。  

### ファイル生成 (terraform template)  
terraform templateを使い、Inventoryを作成します。  
[テンプレートファイル](template/inventory.tpl)に terraform.tfvarsや作成されたVMのIPを与えています。  

- テンプレートの設定
```
data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/template/inventory.tpl")}"

  vars = {
    windows_ip        = "${vsphere_virtual_machine.vm[0].default_ip_address}"
    windows_user      = "${var.template_user}"
    windows_password  = "${var.template_user_password}" 
  }
}
```

- ファイルの生成  
```
  provisioner "local-exec" {
    working_dir = "${path.module}/"
    command = "echo '${data.template_file.ansible_inventory.rendered}' > playbook/hosts/win_inv"
  }
```

### Ansibleの実行  
生成したファイルを指定したコマンドを実行します。  

```
  provisioner "local-exec" {
    working_dir = "${path.module}/"
    command = "ansible-playbook -i playbook/hosts/win_inv playbook/example.yml -vvv"
  }
```

## Terraformの実行  
`terraform init`  
`terraform plan`  
`terraform apply`  

