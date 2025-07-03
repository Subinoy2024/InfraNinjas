

data "azurerm_subnet" "subnet01" {
  name                 = var.name
  virtual_network_name = var.vnetwork
  resource_group_name  = var.resource_Gname
}

data "azurerm_public_ip" "publicIp01" {
  name                = var.pipname
  resource_group_name = var.resource_Gname
}

resource "azurerm_bastion_host" "nasabastion" {
  for_each = var.bastion
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_Gname

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.subnet01.id
    public_ip_address_id = data.azurerm_public_ip.publicIp01.id
  }
}