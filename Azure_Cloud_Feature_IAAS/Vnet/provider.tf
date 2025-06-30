
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
# Create a resource group in Azure hardcoded to "East US"
# Ensure the location matches your Azure region preference

resource "azurerm_resource_group" "rgvnet" {
  name     = "vnet_rg1"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnetname1"
  location            = azurerm_resource_group.rgvnet.location
  resource_group_name = azurerm_resource_group.rgvnet.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  }

  
