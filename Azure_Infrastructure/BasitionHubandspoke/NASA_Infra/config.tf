
module "nasa_resource_group" {
  source              = "../Modules/Azure_Resource"
  resource_group_name = "Nasa_RG_01"
  location            = "Central India"
}

module "keyvaultcreate" {
  source              = "../Modules/Azure_KeyVault"
  depends_on          = [module.nasa_resource_group]
  resource_group_name = "Nasa_RG_01"
  keyvaultName1       = "NasaKeyStorage"
  location            = "central india"
}

module "loginaccesscreate" {
  source              = "../Modules/Azure_Key_Secret"
  depends_on          = [module.nasa_resource_group, module.keyvaultcreate]
  keyvaultName1       = "NasaKeyStorage"
  resource_group_name = "Nasa_RG_01"
  secrate = {
    login = {
      name  = "vmlogin"
      value = "vmadmin"
    }
    login2 = {
      name  = "vmpassword"
      value = "Ipmith@12345"
    }
    login3 = {
      name  = "SQLlogin"
      value = "sqladmin"
    }
    login4 = {
      name  = "sqlpassword"
      value = "Ipmith@12345"
    }
  }

}


module "nashubspoke" {
  source     = "../Modules/Azure_Hub&Spoke_Network"
  depends_on = [module.nasa_resource_group]
  hubspoke = {
    v01 = {
      name                = "hub_vnet01"
      location            = "central india"
      resource_group_name = "Nasa_RG_01"
      address_space       = ["192.168.2.0/26"]
    }
    v012 = {
      name                = "spoke_vnet012"
      location            = "central india"
      resource_group_name = "Nasa_RG_01"
      address_space       = ["192.168.50.0/27"]
    }
    V03 = {
      name                = "spoke_vnet02"
      location            = "central india"
      resource_group_name = "Nasa_RG_01"
      address_space       = ["10.0.20.0/26"]
    }
  }

}

module "subnet" {
  source     = "../Modules/Azure_Subnet"
  depends_on = [module.nasa_resource_group, module.nashubspoke]
  subnet = {
    sbn01 = {
      name                 = "nsub01"
      resource_group_name  = "Nasa_RG_01"
      virtual_network_name = "hub_vnet01"
      address_prefixes     = ["192.168.2.0/27"]

    }
    sbn02 = {
      name                 = "nsub02"
      resource_group_name  = "Nasa_RG_01"
      virtual_network_name = "spoke_vnet012"
      address_prefixes     = ["192.168.50.0/28"]

    }
    sbn03 = {
      name                 = "nsub03"
      resource_group_name  = "Nasa_RG_01"
      virtual_network_name = "spoke_vnet02"
      address_prefixes     = ["10.0.20.0/26"]

    }
  }
}
module "internet01" {
  source     = "../Modules/Azure_Public_IP"
  depends_on = [module.nasa_resource_group, module.nashubspoke, module.subnet]
  internet = {
    int01 = {
      name             = "int_Nasa_01"
      resource_Gname   = "Nasa_RG_01"
      location         = "central india"
      allocationmethod = "Static"
    }
    int02 = {
      name             = "int_Nasa_02"
      resource_Gname   = "Nasa_RG_01"
      location         = "central india"
      allocationmethod = "Static"
    }
    int03 = {
      name             = "int_Nasa_03"
      resource_Gname   = "Nasa_RG_01"
      location         = "central india"
      allocationmethod = "Static"
    }

  }

}

# module "fireallConfig" {
#   source      = "../Modules/Azure_Firewall"
#   depends_on  = [module.nasa_resource_group, module.nashubspoke, module.subnet, module.internet01]
#   name        = "nsub01"
#   vnetwork    = "hub_vnet01"
#   rggroupname = "Nasa_RG_01"
#   pipname     = "int_Nasa_01"
#   firconfig = {
#     nasa_fire_01 = {
#       name                = "NasaFirewall01"
#       location            = "central india"
#       resource_group_name = "Nasa_RG_01"
#       sku_name            = "AZFW_VNet"
#       sku_tier            = "Standard"
#     }
#   }



# }

# module "bastion1" {
#   source         = "../Modules/Azure_Bastion"
#   depends_on     = [module.nasa_resource_group, module.nashubspoke, module.subnet, module.internet01]
#   name           = "nsub01"
#   vnetwork       = "hub_vnet01"
#   resource_Gname = "Nasa_RG_01"
#   pipname        = "int_Nasa_01"
#   bastion = {
#     bas1 = {
#       name           = "BastionUSA01"
#       location       = "central india"
#       resource_Gname = "Nasa_RG_01"
#     }
#   }
# }

# module "vmnic" {
#   source               = "../Modules/Azure_NIC"
#   subnetname           = "nsub02"
#   virtual_network_name = "spoke_vnet012"
#   rggroupname          = "Nasa_RG_01"
#   punlicIpaddress      = "int_Nasa_02"
#   nic0 = {
#     nic001 = {
#       name                = "nic1"
#       location            = "central india"
#       resource_group_name = "Nasa_RG_01"
#     }
#     nic001 = {
#       name                = "nic2"
#       location            = "central india"
#       resource_group_name = "Nasa_RG_01"
#     }
#   }
# }

# module "vmconfig" {
#   source     = "../Modules/Azure_VM"
#   depends_on = [module.nasa_resource_group, module.keyvaultcreate, module.loginaccesscreate, module.nasa_resource_group, module.internet01, module.subnet, module.nashubspoke]
#   subnetname = "nsub02"
#   location   = "central india"
#   #nicname              = "nic1"
#   punlicIpaddress      = "int_Nasa_02"
#   resource_group_name  = "Nasa_RG_01"
#   virtual_network_name = "spoke_vnet012"
#   key_vault_id         = "NasaKeyStorage"
#   #keyvault0            = "NasaKeyStorage"
#   nic = {
#     nic = {
#       name                = "nic4"
#       location            = "central india"
#       resource_group_name = "Nasa_RG_01"

#     }
#   }
#   vms1 = {
#     vm1 = {
#       name                = "VMSRV001"
#       location            = "central india"
#       resource_group_name = "Nasa_RG_01"
#       #size="Standard_F2"
#     }
#   }


# }



module "vmconfig2" {
  source  = "../Modules/VM_Old"
  nicname = "nic02"
  name = "Backend-vm01"
  size    = "Standard_B1s"
  os_disk_caching     = "ReadWrite"
  os_disk_type        = "Standard_LRS"
  location            = "central india"
  virtualNetworks     = "spoke_vnet012"
  resource_group_name = "Nasa_RG_01"
  subnet              = "nsub02"
  pipname             = "int_Nasa_02"
  key_vault_id = "NasaKeyStorage"

  }


