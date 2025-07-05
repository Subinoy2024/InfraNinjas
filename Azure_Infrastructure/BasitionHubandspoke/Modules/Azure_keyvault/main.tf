resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvaultName1
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.Nasa.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.Nasa.tenant_id
    object_id = data.azurerm_client_config.Nasa.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get","Set","List","Delete","Purge","Recover","Restore",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
