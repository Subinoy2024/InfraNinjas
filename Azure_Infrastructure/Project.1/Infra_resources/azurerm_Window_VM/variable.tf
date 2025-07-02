variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string

}

variable "windows_vm_name" {
  description = "The name of the Windows virtual machine"
  type        = string

}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
 
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string

}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
 
}

variable "boot_diagnostics_storage_account_name" {
  description = "The name of the storage account for boot diagnostics"
  type        = string

}
variable "public_ip_id" {
  description = "The ID of the public IP address"
  type        = string

}


