resource "azurerm_virtual_network" "vnet" {
    for_each = var.vnet01
  name                =each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_group
  address_space       = ["192.168.2.0/26"]
}

