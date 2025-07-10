data "azurerm_subnet" "subnet1" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "publicip1" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}  

data "azurerm_key_vault" "keyvault1" {
  name                = "ericssonvault1"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "vmusername" {
  name         = "ericssonwebapp"
  key_vault_id = data.azurerm_key_vault.keyvault1.id
}
data "azurerm_key_vault_secret" "vmpassword" {
  name         = "ericssonwebapp-password"
  key_vault_id = data.azurerm_key_vault.keyvault1.id
}
 
