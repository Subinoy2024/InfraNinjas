resource "azurerm_virtual_network" "nashub_spoke" {
    for_each=var.hubspoke
  name                = each.value.name
  location            = each.value.location
  resource_group_name =each.value.resource_group_name
  address_space       = each.value.address_space
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

