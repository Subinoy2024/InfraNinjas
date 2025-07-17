module "azurerm_resource_group" {
  source      = "../../modules/resource_group"
  ind_rg_name = var.ind_rg_name
  location    = var.location
}
module "Vnet" {
  source="../../modules/vnet"
  count = 3
  vnet001 ="vnet${[count.index]}"
  location=var.location
  resource_group_name=var.ind_rg_name
  address_space = var.address_space

}