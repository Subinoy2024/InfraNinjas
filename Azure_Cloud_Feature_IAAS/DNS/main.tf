

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

#create a public DNS zone in Azure -public DNS zone is used to resolve domain names to IP addresses
resource "azurerm_dns_zone" "public" {
  name                = "my.com1"
  resource_group_name = azurerm_resource_group.rgindia.name
}

  #create a private DNS zone in Azure -private DNS zone is used to resolve domain names to IP addresses -internal network communication with FQDN


resource "azurerm_private_dns_zone" "private" {
  name                = "my.com"
  resource_group_name = azurerm_resource_group.rgindia.name
}

#Create a DNS A record in the public DNS zone with nasted map
resource "azurerm_dns_zone" "public_dns_zone" {
  for_each = var.pubdns_records
  name                = each.value.name
  resource_group_name = each.value.resource_group_name

}

variable "pubdns_records" {

  type = map(any)

  default = {

    dns1 = {
      name = "my.com50"
      resource_group_name="rgindia"
    }

    dns2 = {
      name = "my.com08"
      resource_group_name="rgindia"
    }

  }
}

# Create a DNS A record in the private DNS zone with map
resource "azurerm_dns_zone" "public_dns_zone3" {
  for_each = var.pubdns
  name                = each.key
  resource_group_name = azurerm_resource_group.rgindia.name

}
variable "pubdns"{
  type = map(string)
  default={
    name= "my.com19"
    name2= "my.com20"
    name3= "my.com39"
  }

  }
  

# Create a DNS A record in the public DNS zone with list
resource "azurerm_dns_zone" "dnscount"{
  count = length(var.co)
  name                =var.co[count.index]
  resource_group_name = azurerm_resource_group.rgindia.name
}
variable "co" {
  type = list (string)
  default=["my.com21","my.com22","my.com23"]
}
