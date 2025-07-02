variable "managed_disk_name" {
  description = "The name of the managed disk."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the managed disk will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "storage_account_type" {
  description = "The storage account type for the managed disk."
  type        = string
}
