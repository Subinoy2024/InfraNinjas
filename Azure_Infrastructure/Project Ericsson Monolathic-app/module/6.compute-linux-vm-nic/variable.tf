variable "nic_name" {
  description = "The name of the network interface."
  type        = string

}
variable "nic_location" {
  description = "The location where the network interface will be created."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group where the network interface will be created."
  type        = string
}
variable "ip_configuration_name" {
  description = "The name of the IP configuration for the network interface."
  type        = string
}

variable "private_ip_address_allocation" {
  description = "The method of private IP address allocation for the network interface."
  type        = string

}
variable "azurerm_linux_virtual_machine_name" {
  description = "The name of the Azure Linux virtual machine."
  type        = string
}
variable "azurerm_linux_virtual_machine_location" {
  description = "The location where the Azure Linux virtual machine will be created."
  type        = string
}
variable "linux_vm_size" {
  description = "The size of the Azure Linux virtual machine."
  type        = string
}


variable "subnet_name" {
  description = "The name of the subnet where the network interface will be created."
  type        = string
  
}
variable "virtual_network_name" {
  description = "The name of the virtual network where the subnet is located."
  type        = string
  
}
variable "private_ip_address" {
  description = "The static private IP address to assign to the network interface."
  type        = string
  
  
}

variable "public_ip_name" {
  description = "The name of the public IP address to associate with the network interface."
  type        = string
  
}