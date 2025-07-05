# variable "nic0"{
#     type=map(any)
# }
variable"subnetname"{
    type=string
}
variable"resource_group_name"{
    type=string
}
variable"virtual_network_name"{
    type=string
}
variable"punlicIpaddress"{
    type=string
}

# variable "nic" {
#     type=map(any)
  
# }
# variable "vmname" {
#     type=string
  
# # }
# variable "vms1" {
#     type=map(any)
   
#    }

variable "key_vault_id" {
  type=string
}
# variable "keyvault0" {
#   type=string
# }

variable"location"{
    type=string
}

variable "nic" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}

variable "vms1" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    # Add other VM properties as needed
  }))
}