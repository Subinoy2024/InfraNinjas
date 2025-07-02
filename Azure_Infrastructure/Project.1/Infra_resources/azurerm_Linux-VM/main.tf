resource "azurerm_network_interface" "com-nic" {
  name                = var.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id

    
  }

  
}

resource "azurerm_linux_virtual_machine" "comlinuxVM" {
  name                = var.linux_vm_name
  computer_name       = "mylinuxvm"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "shaurya1234!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.com-nic.id,
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

  custom_data = filebase64("linux_customdata.sh")

  # boot_diagnostics {
    
  #   storage_account_uri = azurerm_storage_account.boot-diagon.primary_blob_endpoint
  # }

 
 
}