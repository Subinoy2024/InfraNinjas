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

# Create a resource group in Azure hardcoded to "West Europe"
resource "azurerm_resource_group" "pandey_rg2" {
  name     = "pandey-rg2611"
  location = "West Europe"
}

#Create a storage account in the resource group
resource "azurerm_storage_account" "pandey_storage2" {
  name                     = "pandeystorage2"
  resource_group_name      = azurerm_resource_group.pandey_rg2.name
  location                 = azurerm_resource_group.pandey_rg2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.pandey_rg2 ]

}


# Create a storage container in the storage account
resource "azurerm_storage_container" "pandey_container2" {
  name                  = "pandeycontainer2"
  storage_account_id    = azurerm_storage_account.pandey_storage2.id
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.pandey_storage2 ]
}

#Create a storage account in the resource group with different names and locations using count
resource "azurerm_storage_account" "pandeystorage3" {
  count                    = length(var.storage_accounts) # Count will create a storage account for each item in the list
  name                     = var.storage_accounts[count.index]
  resource_group_name      = "pandey-rg2611"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

variable "storage_accounts" {
  type = list(string)
  default = [
    "pandeystorage00",
    "pandeystorage01",
    "pandeystorage02"
  ]
}

#Create a storage account in the resource group with for_each using map
resource "azurerm_storage_account" "for_each_storage" {
  for_each                 = var.storage_account_map
  name                     = each.value
  resource_group_name      = azurerm_resource_group.pandey_rg2.name
  location                 = azurerm_resource_group.pandey_rg2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

variable "storage_account_map" {
  default = {
    acc01 = "mystorageacc04"
    acc02 = "mystorageacc05"
  }
}


 




    


