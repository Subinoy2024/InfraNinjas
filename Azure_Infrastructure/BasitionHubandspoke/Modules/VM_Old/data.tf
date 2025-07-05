# 
################




data "azurerm_public_ip" "publicIp01" {
  name                = var.pipname
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
