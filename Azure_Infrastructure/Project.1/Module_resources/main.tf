#This Terraform configuration defines a module for creating an Azure Resource Group.
module "resource_group" {
  source = "../Infra_resources/azurerm_resource_group"
  resource_group_name = "HCL_rg01"
  resource_group_location = "East US"
}

# This Terraform configuration defines a module for creating an Azure Virtual Network.
# It depends on the resource group module to ensure the resource group is created before the virtual network.
module "virtual_network" {
    source = "../Infra_resources/azurerm_virtual_network"
    virtual_network_name = "HCL_vnet01"
    resource_group_name = "HCL_rg01"
    virtual_network_location = "East US"
    virtual_network_address_space = ["10.0.0.0/16"]
    depends_on = [ module.resource_group ]
}

# This Terraform configuration defines a module for creating an Azure Subnet.
# It depends on the virtual network module to ensure the virtual network is created before the subnet.
module "subnet" {
    source = "../Infra_resources/azurerm_subnet"
      subnet_name = "HCL_subnet01"
    virtual_network_name = "HCL_vnet01"
    resource_group_name = "HCL_rg01"
    subnet_address_prefix = ["10.0.1.0/24"]
    depends_on = [ module.virtual_network ]
}

module "subnet2" {
    source = "../Infra_resources/azurerm_subnet"
      subnet_name = "HCL_subnet02"
    virtual_network_name = "HCL_vnet01"
    resource_group_name = "HCL_rg01"
    subnet_address_prefix = ["10.0.2.0/24"]
    depends_on = [ module.virtual_network ]
}


# This Terraform configuration defines a module for creating an Azure Public IP.
module "public_ip" {
    source = "../Infra_resources/azurerm_publicIP"
     public_ip_name = "HCL_publicIP01"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    allocation_method = "Static"
    depends_on = [ module.resource_group ]
}

module "public_ip2" {
    source = "../Infra_resources/azurerm_publicIP"
     public_ip_name = "HCL_publicIP02"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    allocation_method = "Static"
    depends_on = [ module.resource_group ]
}

# This Terraform configuration defines a module for creating an Azure Network Security Group (NSG).
# It includes security rules for SSH and HTTP access.
module "network_security_group" {
    source = "../Infra_resources/azurerm_NSG"
    network_security_group_name = "HCL_NSG01"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    depends_on = [ module.resource_group ]
}

#This Terraform configuration defines a module for creating an Azure Storage Account.
module "storage_account" {
    source = "../Infra_resources/azurerm_Storage"
    storage_account_name = "hclbootdiag01"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    storage_account_tier = "Standard"
    storage_account_replication_type = "GRS"
    depends_on = [ module.resource_group ]
}

#This Terraform configuration defines a module for creating an Azure Managed Disk.
module "managed_disk" {
    source = "../Infra_resources/azurerm_managed_disk"
    managed_disk_name = "HCL_managedDisk01"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    storage_account_type = "Standard_LRS"
    depends_on = [ module.resource_group ]
}

module "vm" {
    source = "../Infra_resources/azurerm_Linux-VM"
    network_interface_name = "HCL_nic01"
    linux_vm_name = "HCL_LinuxVM01"
    custom_data_file = "custom_data.sh"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    public_ip_id = "/subscriptions/6b6841bf-0578-47fa-9c22-85d13fdbef13/resourceGroups/HCL_rg01/providers/Microsoft.Network/publicIPAddresses/HCL_publicIP01"
    boot_diagnostics_storage_account_name = "hclbootdiag01"
    subnet_id = "/subscriptions/6b6841bf-0578-47fa-9c22-85d13fdbef13/resourceGroups/HCL_rg01/providers/Microsoft.Network/virtualNetworks/HCL_vnet01/subnets/HCL_subnet01"
    depends_on = [ module.resource_group, module.virtual_network, module.subnet, module.storage_account ]
}

module "vm2" {
    source = "../Infra_resources/azurerm_Window_VM"
    network_interface_name = "HCL_nic02"
    windows_vm_name = "HCL_WindowsVM01"
    resource_group_name = "HCL_rg01"
    resource_group_location = "East US"
    public_ip_id = "/subscriptions/6b6841bf-0578-47fa-9c22-85d13fdbef13/resourceGroups/HCL_rg01/providers/Microsoft.Network/publicIPAddresses/HCL_publicIP02"
    boot_diagnostics_storage_account_name = "hclbootdiag01"
    subnet_id = "/subscriptions/6b6841bf-0578-47fa-9c22-85d13fdbef13/resourceGroups/HCL_rg01/providers/Microsoft.Network/virtualNetworks/HCL_vnet01/subnets/HCL_subnet02"

    depends_on = [ module.resource_group, module.virtual_network, module.subnet2, module.storage_account ]
}







