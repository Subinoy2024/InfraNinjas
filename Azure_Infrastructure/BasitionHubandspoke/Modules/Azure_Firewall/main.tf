
data "azurerm_subnet" "subnet01" {
  name                 = var.name
  virtual_network_name = var.vnetwork
  resource_group_name  = var.rggroupname
}

data "azurerm_public_ip" "publicIp01" {
  name                = var.pipname
  resource_group_name = var.rggroupname
}


resource "azurerm_firewall" "example" {
    for_each=var.firconfig
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier

ip_configuration {
    name                 = "configuration"
    subnet_id            =data.azurerm_subnet.subnet01.id
    public_ip_address_id = data.azurerm_public_ip.publicIp01.id
  }
}
