resource "azurerm_managed_disk" "com-managed-disk" {
  name                 = var.managed_disk_name
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = "8"
}