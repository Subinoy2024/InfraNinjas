resource "azurerm_resource_group" "ericsson-rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}