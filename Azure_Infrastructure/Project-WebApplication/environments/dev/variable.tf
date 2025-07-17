variable "ind_rg_name" {}
variable "location" {}
variable "vnet001"{
    type=list(number)  #("HNSVnet","SVnet01","Svnet02")
}
variable "address_space"{
      type=set(string)
}