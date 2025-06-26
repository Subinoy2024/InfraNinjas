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