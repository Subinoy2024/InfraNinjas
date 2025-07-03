terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "31a9bebe-109c-426e-9c37-09af652b7cba"
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }

}
