

data "azurerm_subnet" "subnet01" {
  name                 = var.subnetname
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "publicIp01" {
  name                = var.punlicIpaddress
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault" "key" {
  name                = var.key_vault_id
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault_secret" "vmlogon" {
  name         = "vmlogin"
  key_vault_id = data.azurerm_key_vault.key.id
}
data "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.key.id
}


# NIC using subnet and public IP
resource "azurerm_network_interface" "nic1" {
  for_each              = var.nic
  name                  = each.value.name #each.value.name#"${each.key}-nic1"
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.publicIp01.id
  }
}

# VM using NIC and admin credentials
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vms1
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  #size                            = each.value.vm_size
  size                            = "Standard_F2"
  admin_username                  = data.azurerm_key_vault_secret.vmlogon.value
  admin_password                  = data.azurerm_key_vault_secret.vmpassword.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic1[each.key].id,
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

  #network_interface_ids = [azurerm_network_interface[each.key].id]
}
output "nic_keys" {
  value = keys(azurerm_network_interface.nic1)
}