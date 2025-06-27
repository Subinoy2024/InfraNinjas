
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
  subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba" 

}
# Create a resource group in Azure hardcoded to "central india"
# Ensure the location matches your Azure region preference

resource "azurerm_resource_group" "rgindia"{
    name ="rgindia"
    location = "central india"

}


resource "azurerm_dns_zone" "public" {
  name                = "my.com"
  resource_group_name = azurerm_resource_group.rgindia.name
}