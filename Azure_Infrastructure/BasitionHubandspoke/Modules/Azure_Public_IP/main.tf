resource "azurerm_public_ip" "Internet1" {
    for_each=var.internet
  name                = each.value.name
  resource_group_name = each.value.resource_Gname
  location            = each.value.location
  allocation_method   = each.value.allocationmethod
}