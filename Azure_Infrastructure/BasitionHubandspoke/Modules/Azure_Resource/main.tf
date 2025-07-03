resource "azurerm_resource_group" "ind_hub_spoke"{
    name=var.resource_group_name
    location = var.location
}