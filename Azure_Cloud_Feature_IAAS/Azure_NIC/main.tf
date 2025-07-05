
data "azurerm_subnet" "subnet01" {
  name                 = var.subnetname
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.rggroupname
}

data "azurerm_public_ip" "publicIp01" {
  name                = var.punlicIpaddress
  resource_group_name = var.rggroupname
}
resource "azurerm_network_interface" "Nic" {
    for_each =var.nic0
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.publicIp01.id
  }
}