# this is a terraform script to create a resource group in Azure

terraform {

    # Specify the required Terraform version
  required_version = ">= 1.10.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

# Configure the AzureRM provider
# Ensure you have the Azure CLI installed and authenticated
# or use a service principal with the necessary permissions
# You can also set the subscription_id in the provider block if needed
# Make sure to replace the version with the latest one available

provider "azurerm" {
  # Configuration options

  features {}
  # subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba" 
  subscription_id = "6b6841bf-0578-47fa-9c22-85d13fdbef13"

}


resource "azurerm_resource_group" "pandey_rg2" {
  name     = "pandey-rg2611"
  location = "West Europe"
}

resource "azurerm_storage_account" "pandey_storage2" {
  name                     = "pandeystorage2"
  resource_group_name      = azurerm_resource_group.pandey_rg2.name
  location                 = azurerm_resource_group.pandey_rg2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.pandey_rg2 ]

}
    


