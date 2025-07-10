module "resource_group" {
  source                  = "../module/1.resource-group"
  resource_group_name     = "rg-ericsson"
  resource_group_location = "central india"

}

module "resource_group" {
  source                  = "../module/1.resource-group"
  resource_group_name     = "rg-ericsson1"
  resource_group_location = "central india"
}

module "storage_account" {
  depends_on               = [module.resource_group]
  source                   = "../module/2.storage-account"
  storage_account_name     = "ericssonstorageacc"
  resource_group_name      = "rg-ericsson"
  resource_group_location  = "central india"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

module "vnet" {
  depends_on          = [module.resource_group]
  source              = "../module/3.network-vnet"
  vnet_name           = "ericsson-vnet"
  vnet_location       = "central india"
  resource_group_name = "rg-ericsson"
  address_space       = ["10.0.0.0/16"]

}
module "subnet1" {
  depends_on           = [module.vnet, module.resource_group]
  source               = "../module/4.network-subnet"
  subnet_name          = "ericsson-frontendsubnet"
  resource_group_name  = "rg-ericsson"
  virtual_network_name = "ericsson-vnet"
  address_prefixes     = ["10.0.0.0/24"]

}

module "subnet2" {
  depends_on           = [module.vnet, module.resource_group]
  source               = "../module/4.network-subnet"
  subnet_name          = "ericsson-backendsubnet"
  resource_group_name  = "rg-ericsson"
  virtual_network_name = "ericsson-vnet"
  address_prefixes     = ["10.0.2.0/24"]

}
module "public_ip" {
  depends_on              = [module.resource_group, module.vnet, module.subnet1, module.subnet2]
  source                  = "../module/5.public-ip"
  public_ip_name          = "ericsson-public-ip"
  resource_group_name     = "rg-ericsson"
  resource_group_location = "central india"
  allocation_method       = "Static"
}

module "public_ip1" {
  depends_on              = [module.resource_group, module.vnet, module.subnet1, module.subnet2]
  source                  = "../module/5.public-ip"
  public_ip_name          = "ericsson-public-ipnew"
  resource_group_name     = "rg-ericsson"
  resource_group_location = "central india"
  allocation_method       = "Static"
}

module "virtual_machine" {
  depends_on = [module.vnet, module.subnet1, module.public_ip, module.storage_account, module.resource_group,module.subnet2]

  source                        = "../module/6.compute-linux-vm-nic"

  nic_name                      = "ericsson-nic"
  nic_location                  = "central india"
  resource_group_name           = "rg-ericsson"
  ip_configuration_name         = "internal"
  public_ip_name = "ericsson-public-ip"
  private_ip_address_allocation = "Static"
  private_ip_address = "10.0.0.5"

  azurerm_linux_virtual_machine_name     = "vm1"
  azurerm_linux_virtual_machine_location = "central india"
  linux_vm_size                          = "Standard_B1s"
  subnet_name                            = "ericsson-frontendsubnet"
  virtual_network_name                   = "ericsson-vnet"
 
}


module "virtual_machine_backend" {
  depends_on = [module.vnet, module.subnet1, module.public_ip, module.storage_account, module.resource_group,module.subnet2]

  source                        = "../module/6.compute-linux-vm-nic"

  nic_name                      = "ericsson-nic-1"
  nic_location                  = "central india"
  resource_group_name           = "rg-ericsson"
  ip_configuration_name         = "internal"
  private_ip_address_allocation = "Static"
  private_ip_address = "10.0.2.7"
  public_ip_name = "ericsson-public-ipnew"

  azurerm_linux_virtual_machine_name     = "vmbackend"
  azurerm_linux_virtual_machine_location = "central india"
  linux_vm_size                          = "Standard_B1s"
  subnet_name                            = "ericsson-backendsubnet"
  virtual_network_name                   = "ericsson-vnet"
 
}

module "mssql_server" {
  depends_on = [module.virtual_machine, module.virtual_machine_backend]
  source = "../module/7.mssql-server"
  sql_server_name = "ericsson-sqlserver"
  resource_group_name = "rg-ericsson"
  resource_group_location = "central india"
  administrator_login = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"
}

module "mssql_database" { 
  depends_on = [ module.virtual_machine ,module.virtual_machine_backend, module.mssql_server]
  source = "../module/8.mssql-database"
  database_name = "databasevm"
  server_id = "/subscriptions/bce8e725-3bb6-431a-b792-a07a35bfa7e1/resourceGroups/rg-ericsson/providers/Microsoft.Sql/servers/ericsson-sqlserver"
  collation = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb = 2
  sku_name = "S0"
  enclave_type = "VBS"
}


