
module "nasa_resource_group" {
  source              = "../Modules/Azure_Resource"
  resource_group_name = "Nasa_RG_01"
  location            = "Central India"
}


module "nashubspoke" {
  source     = "../Modules/Azure_Hub&Spoke_Network"
  depends_on = [module.nasa_resource_group]
  hubspoke = {
    v01 = {
      name          = "hub_vnet01"
      location      = "central india"
      rg_group      = "NaSaRg001"
      address_space = ["192.168.2.0/26"]
    }
    v012 = {
      name          = "spoke_vnet012"
      location      = "central india"
      rg_group      = "NaSaRg001"
      address_space = ["192.168.50.0/27"]
    }
    V03 = {
      name          = "spoke_vnet02"
      location      = "central india"
      rg_group      = "NaSaRg001"
      address_space = ["192.168.0.0/28"]
    }
  }

}

module "subnet"{
  source = "../Modules/Azure_Subnet"
  depends_on = [ module.nashubspoke ]
  subnet = {
    sbn01={
      name="nsub01"
      resource_group_name="NaSaRg001"
      virtual_network_name="hub_vnet01"
      address_space=["192.168.2.0/27"]

    }
    sbn02={
      name="nsub02"
      resource_group_name="NaSaRg002"
      virtual_network_name="spoke_vnet012"
      address_space=["192.168.50.0/28"]

    }
    sbn03={
      name="nsub03"
      resource_group_name="NaSaRg003"
      virtual_network_name="spoke_vnet02"
      address_space=["192.168.0.0/28	"]

    }
  }
}


