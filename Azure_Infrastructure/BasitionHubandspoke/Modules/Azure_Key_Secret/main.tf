
data "azurerm_key_vault" "keyvaultinfo" {
  name                = var.keyvaultName1
  resource_group_name = var.resource_group_name
}
resource "azurerm_key_vault_secret" "login" {
for_each = var.secrate
name = each.value.name
value = each.value.value
key_vault_id = data.azurerm_key_vault.keyvaultinfo.id

 lifecycle {
    ignore_changes = [value]
  }
}

