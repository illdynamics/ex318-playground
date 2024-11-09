[ovirt_all]
${engine_hostname} ansible_user=${adm_username} ansible_ssh_private_key_file=${ssh_private_key} ansible_ssh_host=${engine_ip} ansible_ssh_user=${adm_username} ansible_become=yes ansible_password=${adm_password}
${host_hostname} ansible_user=${adm_username} ansible_ssh_private_key_file=${ssh_private_key} ansible_ssh_host=${host_ip} ansible_ssh_user=${adm_username} ansible_become=yes ansible_password=${adm_password}

[ovirt_engines]
${engine_hostname} ansible_user=${adm_username} ansible_ssh_private_key_file=${ssh_private_key} ansible_ssh_host=${engine_ip} ansible_ssh_user=${adm_username} ansible_become=yes ansible_password=${adm_password}

[ovirt_hosts]
${host_hostname} ansible_user=${adm_username} ansible_ssh_private_key_file=${ssh_private_key} ansible_ssh_host=${host_ip} ansible_ssh_user=${adm_username} ansible_become=yes ansible_password=${adm_password}
