variable "rg1" {
  type    = string
  default = "DebnathCrop2026"
}

variable "loc1" {
  type    = string
  default = "South India"
}

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
  default = "internet"
}
variable "nsg" {
  type    = string
  default = "Ind_nsg01"
}

