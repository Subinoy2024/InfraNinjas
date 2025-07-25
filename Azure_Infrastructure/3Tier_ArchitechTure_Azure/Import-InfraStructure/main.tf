provider "azurerm" {
  features {}
  subscription_id = "3d88343d-13f8-4ac6-9b35-44e30ba1e895"

}

terraform {
  backend "azurerm" {
    storage_account_name = "storagesubinoy"
    access_key           = "kjaB5wqIl5dY2mmSXUOLh79zsjLYDGP0ibAit+IUGS62Ja318RbhDaAx7jUet0CItdlUOcGDH7Te+AStJ5+Kzw=="
    resource_group_name  = "subinoy"
    container_name       = "subdebna"
    key                  = "subdebna3import.tfstate"

  }
}

resource "azurerm_resource_group" "inddc01" {
  name     = "VPN_IND_UK_DATACENTER"
  location = "uksouth"
}

resource "azurerm_virtual_network" "indvnat"{
name = "ind-datacenter01"
location = "centralindia"
address_space = ["192.168.201.0/25"]
resource_group_name ="VPN_IND_UK_DATACENTER" 
}