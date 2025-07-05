/*
data "template_file" "cloudinitdata" {
  template = file("deploy.sh")
}
*/

data "azurerm_subnet" "subnet" {
  name                 = var.subnet
  virtual_network_name = var.virtualNetworks
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_interface" "nic" {
  name                = var.nicname
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address_version = var.subnet_id
    public_ip_address_id       = data.azurerm_public_ip.publicIp01.id
    
  }
}


resource "azurerm_linux_virtual_machine" "vm001" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = data.azurerm_key_vault_secret.vmlogon.value
  disable_password_authentication = false # Set to true if using SSH keys instead of password
  admin_password            = data.azurerm_key_vault_secret.vmpassword.value # Use a secure password or SSH key in production
   #custom_data = base64encode(data.template_file.cloudinitdata.rendered)
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]


  os_disk {
    caching              =var.os_disk_caching
    storage_account_type = var.os_disk_type
      # caching              ="Standard_LRS" 
      # storage_account_type = "ReadWrite"
  }

 source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  # Pass the cloud-init script to the VM
  #custom_data = data.template_file.cloudinitdata.rendered
}
