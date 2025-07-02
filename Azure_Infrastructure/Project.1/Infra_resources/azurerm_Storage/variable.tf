variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
  
}

variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "storage_account_tier" {
  description = "The tier of the storage account."
  type        = string
}

variable "storage_account_replication_type" {
  description = "The replication type of the storage account."
  type        = string
}
