resource "azurerm_virtual_network" "vnet_glb" {
  name                =var.vnet001
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}
  #dns_servers         = ["10.0.0.4", "10.0.0.5"
 #resource "azurerm_virtual_network" "dcvnet" {
#   name                = var.vnet01
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_space       = var.address_space

# }
