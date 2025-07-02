# This file is part of the Terraform configuration for managing Azure resources.
# It defines the required provider and its version, as well as the Azure subscription to be used.
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "6b6841bf-0578-47fa-9c22-85d13fdbef13"
}