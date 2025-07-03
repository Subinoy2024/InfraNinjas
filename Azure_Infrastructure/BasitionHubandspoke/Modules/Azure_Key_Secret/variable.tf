variable "keyvaultName1" {
  type = string
  description = "keyvaultName"
}
variable "resource_group_name" {
  type = string
  description = "rg group name"
}

# variable "secrate" {
#   type = map (any( {
#   name= string
#   value= string
#   }))
# }


variable "secrate" {
  description = "The name of the resource group"
  type        = map(any)
}



