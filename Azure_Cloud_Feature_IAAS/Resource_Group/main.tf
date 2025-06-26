
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  # Configuration options


  features {}
  subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba" 

}

# resource "azurerm_resource_group" "RGgroup" {
#   Name     = "Ind_RG_01"
#   Location = "Central India"
# }
resource "azurerm_resource_group" "RGgroup2" {
  Name     = "Ind_RG_02"
  Location = "Central India"
}