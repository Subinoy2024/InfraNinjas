terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba"

}

terraform {
  backend "azurerm" {
    storage_account_name ="storagesubinoy"
    access_key = "kjaB5wqIl5dY2mmSXUOLh79zsjLYDGP0ibAit+IUGS62Ja318RbhDaAx7jUet0CItdlUOcGDH7Te+AStJ5+Kzw=="
    resource_group_name = "subinoy"
    container_name = "subdebna"
    key = "subdebna2.tfstate"
    
  }
}
#azure resource group creation
resource "azurerm_resource_group" "dind" {
  name     = "pandya2"
  location = "central india"
  
}

output "RG001_Name" {
  value = azurerm_resource_group.devOps1.name
}

output "Rg001_Loc" {
  value = azurerm_resource_group.devOps1.location
}

#Azure vnet ceation for corp
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet1
  resource_group_name = var.rg1
  location            = var.loc1
  address_space       = var.cidr_range
  depends_on = [ azurerm_resource_group.devOps ]
}

resource "azurerm_subnet" "sub_IND" {
  name                 = var.subname
  resource_group_name  = var.rg1
  virtual_network_name = var.vnet1
  address_prefixes     = var.prefixes
  depends_on = [ azurerm_resource_group.devOps,azurerm_virtual_network.vnet ]
}

resource "azurerm_public_ip" "Internet" {
  name                = var.internet01
  resource_group_name = var.rg1
  allocation_method   = "Static"
  location            = var.loc1
depends_on = [ azurerm_resource_group.devOps,azurerm_virtual_network.vnet ]
}
