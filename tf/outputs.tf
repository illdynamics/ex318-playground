output "public_ips" {
  value = [for ip in azurerm_public_ip.ovirt : ip.ip_address]
}

output "fqdns" {
  value = [for ip in azurerm_public_ip.ovirt : "${ip.domain_name_label}.${var.location}.cloudapp.azure.com"]
}

output "private_ips" {
  value = [for nic in azurerm_network_interface.ovirt : nic.private_ip_address]
}

output "ansible_inventory" {
  value             = templatefile(var.inventory_template, {
    engine_ip       = azurerm_public_ip.ovirt[0].ip_address
    engine_hostname = azurerm_virtual_machine.ovirt[0].name
    host_ip         = azurerm_public_ip.ovirt[1].ip_address
    host_hostname   = azurerm_virtual_machine.ovirt[1].name
    adm_username    = var.adm_username
    ssh_private_key = var.ssh_private_key
    adm_password    = var.adm_password
  })
  sensitive         = true
}

output "hosts_file" {
  value               = templatefile(var.hosts_template, {
    engine_private_ip = azurerm_network_interface.ovirt[0].private_ip_address
    engine_fqdn       = var.engine_fqdn
    host_private_ip   = azurerm_network_interface.ovirt[1].private_ip_address
    host_fqdn         = var.host_fqdn
  })
  sensitive           = false
}
