terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
}
provider "azurerm" {
features {}
subscription_id = "bce8e725-3bb6-431a-b792-a07a35bfa7e1"
}