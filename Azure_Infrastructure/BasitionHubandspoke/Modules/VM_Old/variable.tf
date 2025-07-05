
variable "nicname" {
    description = "The name of the virtual network."
    type        = string
  
}
variable "location" {
    description = "The address space for the virtual network."
    type        = string
 
}


variable "resource_group_name" {
  description = "The Azure region where the resource group will be created."
  type        = string
  
  
}

variable "name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "size" {
  description = "The size of the virtual machine."
  type        = string
  
}
# variable "admin_username" {
#   description = "The administrator username for the virtual machine."
#   type        = string
# }
# variable "admin_password" {
#   description = "The administrator password for the virtual machine."
#   type        = string
#   sensitive   = true

variable "os_disk_caching" {
  description = "The name of the OS disk."
  type        = string
}
variable "os_disk_type" {
  description = "The type of the OS disk."
  type        = string
  
}
/*
variable "source_image_reference" {     
    description = "The source image reference for the virtual machine."
    type        = object({
        publisher = string
        offer     = string
        sku       = string
        version   = string
    })
}
*/
variable "subnet" {
  description = "The subnet configuration for the virtual machine."
  type=string
  }
  variable "virtualNetworks" {
    description = "The name of the virtual network."
    type        = string
    
  }
variable "key_vault_id" {

  
}

# variable"subnet"{
#     type=string
# }

variable"pipname"{
    type=string
}
# variable "vm" {
#   type=map(any)



#   }


