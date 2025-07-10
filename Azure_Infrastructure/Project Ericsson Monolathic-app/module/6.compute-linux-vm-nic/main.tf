resource "azurerm_network_interface" "ericssonnic" {
  name                = var.nic_name
  location            = var.nic_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address = var.private_ip_address
    public_ip_address_id          = data.azurerm_public_ip.publicip1.id


  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.azurerm_linux_virtual_machine_name
  resource_group_name             = var.resource_group_name
  location                        = var.azurerm_linux_virtual_machine_location
  size                            = var.linux_vm_size
  admin_username                  = data.azurerm_key_vault_secret.vmusername.value
  admin_password                  = data.azurerm_key_vault_secret.vmpassword.value
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.ericssonnic.id
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  custom_data = base64encode(<<-EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
EOF

)
}



