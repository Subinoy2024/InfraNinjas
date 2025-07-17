terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  
features{}
subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba"

}