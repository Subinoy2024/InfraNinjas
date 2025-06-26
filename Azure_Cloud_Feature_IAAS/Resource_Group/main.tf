
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

#create a 3 resource group in Azure with difernt names and locations with map

resource "azurerm_resource_group" "rggroup"{
for_each = var.resource_groups 
name= each.key #key will be the name of the resource group
location=each.value # value will be the location of the resource group
}

variable "resource_groups"{
type=map(string)
default = {
rg="East US"
rg2="West Europe"
rg3="Central India"
}
}

#create a resource group in Azure with different names and locations using count

resource "azurerm_resource_group" "rgglb" {
  count =length(var.rgg) # Count will create a resource group for each item in the list
  name=var.rgg[count.index] #
  location = "eastus" # You can change this to any valid Azure region

}

variable "rgg" {
    type = list(string) 
default =["rg10","rg21","rg40"]
}



#for each with toset to create resource group with different names and locations

resource "azurerm_resource_group" "rgindia12"{
    for_each = toset(var.rgg123) # Convert the set to a map for for_each
    name = each.key # Use the key to access the set
    location = "central india"
}

    variable "rgg123" {
        type = set(string) 
        default = ["rg133","rg33","rg33"]
    }





#nested map for_each to create resource group with different names and locations

resource "azurerm_resource_group" "rgindia123456"{
    for_each = var.nested_map # Use the nested map variable
    name = each.value.name # Access the name from the nested map
    location =each.value.location # Access the location from the nested map
}

variable "nested_map" {
        type = map(map(any)) # Define a nested map variable

        default = {
            rg1 = {
                name = "rg1"
                location = "East US"
            }
            rg2 = {
                name = "rg2"
                location = "West Europe"
            }
            rg3 = {
                name = "rg3"
                location = "Central India"
            }
        }
}