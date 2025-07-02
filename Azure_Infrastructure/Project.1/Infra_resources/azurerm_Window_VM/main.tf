resource "azurerm_network_interface" "com-nic1" {
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

resource "azurerm_windows_virtual_machine" "windowvm" {
  name                = var.windows_vm_name
  computer_name       = "mywindowvm"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "shaurya1234!"
  network_interface_ids = [
    azurerm_network_interface.com-nic1.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  custom_data = filebase64("windows_customdata.ps1")



  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.boot-diagon.primary_blob_endpoint
  # }
}