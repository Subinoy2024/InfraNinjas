variable "vnet001"{
    type = string
}
variable"location"{
    type = string
}

variable "resource_group_name"{
    type=string
}

variable "address_space"{
    type=set(string)
    }