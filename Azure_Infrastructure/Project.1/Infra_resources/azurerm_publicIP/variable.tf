variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "allocation_method" {
  description = "Allocation method for the public IP address"
  type        = string
  
}