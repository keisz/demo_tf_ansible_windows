#Variable
##Define Variables for Platform
variable "vsphere_user" {}          #vsphereのユーザー名
variable "vsphere_password" {}      #vsphereのパスワード
variable "vsphere_vc_server" {}     #vCenterのFQDN/IPアドレス
variable "vsphere_datacenter" {}    #vsphereのデータセンター
variable "vsphere_datastore" {}     #vsphereのデータストア
variable "vsphere_cluster" {}       #vsphereのクラスター
variable "vsphere_network_1" {}     #vsphereのネットワーク
variable "vsphere_resource_pool" {} #ResourcePool名
variable "vsphere_template_name" {} #プロビジョニングするテンプレート

##Network param
variable "pram_domain_name" {}  #仮想マシンが参加するドメイン名
variable "pram_ipv4_subnet" {}  #仮想マシンのネットワークのサブネット
variable "pram_ipv4_gateway" {} #仮想マシンのネットワークのデフォルトゲートウェイ
variable "pram_dns_server" {}   #仮想マシンが参照するDNSサーバー
variable "pram_ipv4_class" {}   #利用できるクラスCの値を指定
variable "pram_ipv4_host" {}    #プロビジョニングする仮想マシンに割り当てるIPアドレスの最初の値

##Define Variables for Virtual Machines
variable "prov_vm_num" {}        #プロビジョニングする仮想マシンの数
variable "prov_vmname_prefix" {} #プロビジョニングする仮想マシンの接頭語
variable "prov_cpu_num" {}       #プロビジョニングする仮想マシンのCPUの数
variable "prov_mem_num" {}       #プロビジョニングする仮想マシンのメモリのMB
variable "prov_firmware" {}      #テンプレートのFirmware

##template user/password
variable "template_user" {}
variable "template_user_password" {}

##Windows Custom
variable "domain_admin_user" {}
variable "domain_admin_password" {}

