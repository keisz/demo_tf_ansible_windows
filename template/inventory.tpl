[all]
${windows_ip}

[all:vars]
ansible_user=${windows_user}
ansible_password=${windows_password}
ansible_connection=winrm
ansible_winrm_scheme=https
ansible_port=5986
ansible_winrm_server_cert_validation=ignore