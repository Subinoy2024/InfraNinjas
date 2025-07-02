module "rg_group"{
    source="../../Re-Usable_Azure_InfraModules/Azure_Resource_Group"
    name="Ind_01_RG"
    location="central india"
}
module "vnet"{
source= "../../Re-Usable_Azure_InfraModules/Azure_Hub&Spoke"
depends_on = [ module.rg_group ]
vnet01 = {
  v01={
    name="hub_vnet01"
    location="central india"
    rg_group="Ind_01_RG"
    address_space=["192.168.2.0/26"]
  }
  02={
    name="spoke_vnet01"
    location="central india"
    rg_group="Ind_01_RG"
    address_space=["192.168.2.0/27"]
  }
  03={
    name="spoke_vnet02"
    location="central india"
    rg_group="Ind_01_RG"
    address_space=["192.168.2.32/27"]
  }
}

}

