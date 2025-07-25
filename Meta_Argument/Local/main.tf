terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba"
  resource_provider_registrations = "none"

}

locals {

  owner="Lata"
}

resource "azurerm_resource_group" "rg"{
    name="Nishant"
    location = "uksouth"
}

output "rg" {
  value = azurerm_resource_group.rg.location
}
output "rg1" {
  value = azurerm_resource_group.rg.name
}