terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba"
  features {}
  }
