resource "azurerm_subnet" "com-subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.subnet_address_prefix
 }