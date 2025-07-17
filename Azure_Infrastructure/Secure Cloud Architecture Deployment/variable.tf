# variable "vnetname" {
#   type    = list(string)
#   default = ["subinoy-VNET-Core", "subinoy-VNET-Services"]
# }
variable "location" {
  type    = string
  default = "East US"
}
variable "rgname" {
  type    = string
  default = "subinoy-RG"
}
# variable "cidr" {
#   type    = list(string)
#   default = ["192.168.0.0/16", "10.10.0.0/16"]
# }

# variable "security_rule" {
# type=map(object)
# default={
#     name                       = string
#     priority                   = number
#     direction                  = string
#     access                     = string
#     protocol                   = string
#     source_port_range          = list
#     destination_port_range     = number
#     source_address_prefix      = string
#     destination_address_prefix = string
# }
# }
