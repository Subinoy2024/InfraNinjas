

variable "cidr_range" {
  type    = set(string)
  default = ["101.0.0.0/26"]
}
variable "vnet1" {
  type    = string
  default = "INDVNET01" #02
}

variable "prefixes" {
  type    = set(string)
  default = ["101.0.0.16/28"]
}
variable "subname" {
  type    = string
  default = "Ind_SUB01"
}
variable "internet01" {
  type    = string
  default = "internet1"
}
variable "internet02" {
  type    = string
  default = "internet2"
}

variable "nsg2_rules" {
  type=map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "frontendendpoint" {
  type=string
}


