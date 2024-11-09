resource "tfe_organization" "test" {
  name  = "testorganisation"
  email = "admin@company.com"
}

resource "tfe_workspace" "test" {
  name         = "ovirt"
  organization = tfe_organization.test-organization.name
  tag_names    = ["test", "ovirt"]
}

resource "tfe_project" "test" {
  organization = tfe_organization.test-organization.name
  name         = "EX318-Playground"
}

resource "azurerm_resource_group" "ovirt" {
  location = var.location
  name     = "ovirt"
}

resource "azurerm_virtual_network" "ovirt" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.ovirt.name
}

resource "azurerm_subnet" "ovirt" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.ovirt.name
  virtual_network_name = azurerm_virtual_network.ovirt.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_public_ip" "ovirt" {
  count               = 2
  name                = "${var.prefix}-pubip-${count.index}"
  location            = azurerm_resource_group.ovirt.location
  resource_group_name = azurerm_resource_group.ovirt.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}${count.index}"
}

resource "azurerm_network_interface" "ovirt" {
  count               = 2
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.ovirt.location
  resource_group_name = azurerm_resource_group.ovirt.name

  ip_configuration {
    name                          = "${var.prefix}-internal"
    subnet_id                     = azurerm_subnet.ovirt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ovirt[count.index].id
  }
  lifecycle {
    ignore_changes=all
  } 
}

resource "azurerm_network_security_group" "ovirt" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.ovirt.location
  resource_group_name = azurerm_resource_group.ovirt.name
}

resource "azurerm_network_security_rule" "ovirt" {
  name                        = "${var.prefix}-incoming"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "80", "443", "9090"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ovirt.name
  network_security_group_name = azurerm_network_security_group.ovirt.name
}

resource "azurerm_virtual_machine" "ovirt" {
  count                            = 2
  name                             = "${var.prefix}-vm-${count.index}"
  location                         = azurerm_resource_group.ovirt.location
  resource_group_name              = azurerm_resource_group.ovirt.name
  network_interface_ids            = [azurerm_network_interface.ovirt[count.index].id]
  vm_size                          = "Standard_D2_v4"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  tags = {
    environment         = "test"
    application         = "ovirt"
  }

  storage_os_disk {
    name                          = "${var.prefix}-osdisk-${count.index}"
    caching                       = "ReadWrite"
    create_option                 = "FromImage"
    managed_disk_type             = "Standard_LRS"
    disk_size_gb                  = 64
  }

  storage_image_reference {
    offer     = "CentOS"
    publisher = "OpenLogic"
    sku       = "8_5-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-${count.index}"
    admin_username = var.adm_username
    admin_password = var.adm_password
  }

  os_profile_linux_config {
    ssh_keys {
      path     = "/home/${var.adm_username}/.ssh/authorized_keys"
      key_data = file(var.ssh_public_key)
    }
    disable_password_authentication = true
  }
}

resource "ansible_group" "ovirt_all" {
  name = "${var.prefix}_all"
  children = azurerm_virtual_machine.ovirt[*].name
}

resource "ansible_group" "ovirt_engines" {
  name     = "${var.prefix}_${var.roles[0]}s"
  children = [azurerm_virtual_machine.ovirt[0].name]
}

resource "ansible_group" "ovirt_hosts" {
  name     = "${var.prefix}_${var.roles[1]}s"
  children = [azurerm_virtual_machine.ovirt[1].name]
}

resource "ansible_host" "ovirt_vm_0" {
  name      = azurerm_virtual_machine.ovirt[0].name
  groups    = ["${var.prefix}_${var.roles[0]}s"]
  variables = {
    ansible_ssh_user             = var.adm_username
    ansible_ssh_private_key_file = var.ssh_private_key
    ansible_ssh_host             = azurerm_public_ip.ovirt[0].ip_address
  }
}

resource "ansible_host" "ovirt_vm_1" {
  name      = azurerm_virtual_machine.ovirt[1].name
  groups    = ["${var.prefix}_${var.roles[1]}s"]
  variables = {
    ansible_ssh_user             = var.adm_username
    ansible_ssh_private_key_file = var.ssh_private_key
    ansible_ssh_host             = azurerm_public_ip.ovirt[1].ip_address
  }
}

resource "local_file" "inventory" {
  content              = templatefile(var.inventory_template, {
    engine_ip          = azurerm_public_ip.ovirt[0].ip_address
    engine_hostname    = azurerm_virtual_machine.ovirt[0].name
    host_ip            = azurerm_public_ip.ovirt[1].ip_address
    host_hostname      = azurerm_virtual_machine.ovirt[1].name
    adm_username       = var.adm_username
    ssh_private_key    = var.ssh_private_key
    adm_password       = var.adm_password
  })
  filename             = "files/${var.inventory_file}"
  directory_permission = 0755
  file_permission      = 0644
}

resource "local_file" "hosts_file" {
  content              = templatefile(var.hosts_template, {
    engine_private_ip  = azurerm_network_interface.ovirt[0].private_ip_address
    engine_fqdn        = var.engine_fqdn
    host_private_ip    = azurerm_network_interface.ovirt[1].private_ip_address
    host_fqdn          = var.host_fqdn
  })
  filename             = "files/${var.hosts_file}"
  directory_permission = 0755
  file_permission      = 0644
}

