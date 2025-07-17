resource "azurerm_resource_group" "subinoy-Resource-Group" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_virtual_network" "Subinoy-VNET0" {


  #   count               = 2
  #   name                = var.vnetname[count.index]
  #   location            = var.location
  #   resource_group_name = var.rgname
  #   address_space       = [var.cidr[count.index]]
  # 
  name                = "subinoy-VNET-Core"
  location            = var.location
  resource_group_name = var.rgname
  address_space       = ["192.168.0.0/16"]
  depends_on          = [azurerm_resource_group.subinoy-Resource-Group]
}

resource "azurerm_virtual_network" "Subinoy-VNET1" {

  name                = "subinoy-VNET-Services"
  location            = var.location
  resource_group_name = var.rgname
  address_space       = ["10.10.0.0/16"]
  depends_on          = [azurerm_resource_group.subinoy-Resource-Group,azurerm_virtual_network.Subinoy-VNET0]

}
resource "azurerm_subnet" "VNET-Core-subnet" {
  name                 = "subinoy-VNET-Core-Web"
  resource_group_name  = var.rgname
  virtual_network_name = "subinoy-VNET-Core"
  address_prefixes     = ["192.168.10.0/24"]
  depends_on           = [azurerm_virtual_network.Subinoy-VNET0,azurerm_virtual_network.Subinoy-VNET1,azurerm_resource_group.subinoy-Resource-Group]
}


resource "azurerm_subnet" "VNET-Core-subnet2" {
  name                 = "subinoy-VNET-Core-Mgmt"
  resource_group_name  = var.rgname
  virtual_network_name = "subinoy-VNET-Core"
  address_prefixes     = ["192.168.20.0/24"]
  depends_on           = [azurerm_resource_group.subinoy-Resource-Group,azurerm_virtual_network.Subinoy-VNET0]
}

resource "azurerm_subnet" "VNET-Services-subnet" {
  name                 = "subinoy-VNET-Services-Data"
  resource_group_name  = var.rgname
  virtual_network_name = "subinoy-VNET-Services"
  address_prefixes     = ["10.10.1.0/24"]
depends_on = [ azurerm_resource_group.subinoy-Resource-Group,azurerm_virtual_network.Subinoy-VNET0,azurerm_virtual_network.Subinoy-VNET1,azurerm_subnet.VNET-Core-subnet,azurerm_subnet.VNET-Core-subnet2 ]
}

#Vnet Peering

resource "azurerm_virtual_network_peering" "Subinoy-VNETP0" {
  name                      = "VNET-CoreTOVNET-Services"
  resource_group_name       = var.rgname
  virtual_network_name      = azurerm_virtual_network.Subinoy-VNET0.name
  remote_virtual_network_id = azurerm_virtual_network.Subinoy-VNET1.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
  depends_on                = [azurerm_virtual_network.Subinoy-VNET0, azurerm_virtual_network.Subinoy-VNET1, azurerm_resource_group.subinoy-Resource-Group]
}

resource "azurerm_virtual_network_peering" "Subinoy-VNETP1" {
  name                      = "VNET-ServicesTOVNET-Core"
  resource_group_name       = var.rgname
  virtual_network_name      = azurerm_virtual_network.Subinoy-VNET1.name
  remote_virtual_network_id = azurerm_virtual_network.Subinoy-VNET0.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
  depends_on                = [azurerm_virtual_network.Subinoy-VNET0, azurerm_virtual_network.Subinoy-VNET1, azurerm_resource_group.subinoy-Resource-Group]
}

#Nsg
resource "azurerm_network_security_group" "NSG" {
  name                = "MgmtVM"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "allowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.subinoy-Resource-Group ]
}
resource "azurerm_network_security_group" "NSG1" {
  name                = "WebVM"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "allow_http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    depends_on = [ azurerm_resource_group.subinoy-Resource-Group ]
}
resource "azurerm_network_security_group" "NSG2" {
  name                = "DataVM"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "allowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.subinoy-Resource-Group ]
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  subnet_id                 = azurerm_subnet.VNET-Core-subnet.id
  network_security_group_id = azurerm_network_security_group.NSG.id
  depends_on = [ azurerm_network_security_group.NSG,azurerm_subnet.VNET-Core-subnet,azurerm_virtual_network.Subinoy-VNET0,azurerm_virtual_network.Subinoy-VNET1 ]
}

resource "azurerm_subnet_network_security_group_association" "nsg1" {
  subnet_id                 = azurerm_subnet.VNET-Core-subnet2.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
  depends_on = [ azurerm_network_security_group.NSG,azurerm_subnet.VNET-Core-subnet2,azurerm_virtual_network.Subinoy-VNET0,azurerm_virtual_network.Subinoy-VNET1 ]
}

resource "azurerm_subnet_network_security_group_association" "nsg3" {
  subnet_id                 = azurerm_subnet.VNET-Services-subnet.id
  network_security_group_id = azurerm_network_security_group.NSG2.id
  depends_on = [ azurerm_subnet.VNET-Services-subnet,azurerm_virtual_network.Subinoy-VNET1 ]
}


resource "azurerm_public_ip" "public_Internet" {
  name                = "subinoy_publicIP"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.subinoy-Resource-Group ]
}
resource "azurerm_public_ip" "public_Internet2" {
  name                = "subinoy_publicIP2"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.subinoy-Resource-Group ]
}
#VM
resource "azurerm_network_interface" "windowsMGMTNIC" {
  name                = "NIC01"
  location            = azurerm_resource_group.subinoy-Resource-Group.location
  resource_group_name = azurerm_resource_group.subinoy-Resource-Group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.VNET-Core-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_Internet.id
  }
  depends_on = [azurerm_resource_group.subinoy-Resource-Group, azurerm_virtual_network.Subinoy-VNET0]
}

resource "azurerm_windows_virtual_machine" "windowsMGMTVM" {
  name                = "subinoy-MgmtVM"
  resource_group_name = azurerm_resource_group.subinoy-Resource-Group.name
  location            = azurerm_resource_group.subinoy-Resource-Group.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  #disable_password_authentication = true
  admin_password      = "Ipmith@123456"
  
  
  network_interface_ids = [
    azurerm_network_interface.windowsMGMTNIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.subinoy-Resource-Group, azurerm_virtual_network.Subinoy-VNET0]
}

#VM1
resource "azurerm_network_interface" "windowsdataNIC" {
  name                = "NIC02"
  location            = azurerm_resource_group.subinoy-Resource-Group.location
  resource_group_name = azurerm_resource_group.subinoy-Resource-Group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.VNET-Services-subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = ""
  }
  depends_on = [azurerm_resource_group.subinoy-Resource-Group, azurerm_virtual_network.Subinoy-VNET0,azurerm_subnet.VNET-Core-subnet]
}

resource "azurerm_windows_virtual_machine" "windowsdataVM" {
  name                = "subinoy-DataVM"
  resource_group_name = azurerm_resource_group.subinoy-Resource-Group.name
  location            = azurerm_resource_group.subinoy-Resource-Group.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "Ipmith@123456"
  
  network_interface_ids = [
    azurerm_network_interface.windowsdataNIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.subinoy-Resource-Group, azurerm_virtual_network.Subinoy-VNET1,azurerm_subnet.VNET-Services-subnet]
}

#VM3
resource "azurerm_network_interface" "linuxWebNic" {
  name                = "NIC03"
  location            = azurerm_resource_group.subinoy-Resource-Group.location
  resource_group_name = azurerm_resource_group.subinoy-Resource-Group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.VNET-Core-subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_Internet2.id
  }
}

resource "azurerm_linux_virtual_machine" "linuxWebVM" {
  name                = "subinoy-WEBVM"
  resource_group_name = azurerm_resource_group.subinoy-Resource-Group.name
  location            = azurerm_resource_group.subinoy-Resource-Group.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  disable_password_authentication = false
  admin_password      = "Ipmith@123456"
  network_interface_ids = [
    azurerm_network_interface.linuxWebNic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.subinoy-Resource-Group,azurerm_virtual_network.Subinoy-VNET0,azurerm_subnet.VNET-Core-subnet2]
}

