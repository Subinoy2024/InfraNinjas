terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "3d88343d-13f8-4ac6-9b35-44e30ba1e895"

}


terraform {
  backend "azurerm" {
    storage_account_name = "storagesubinoy"
    access_key           = "kjaB5wqIl5dY2mmSXUOLh79zsjLYDGP0ibAit+IUGS62Ja318RbhDaAx7jUet0CItdlUOcGDH7Te+AStJ5+Kzw=="
    resource_group_name  = "subinoy"
    container_name       = "subdebna"
    key                  = "subdebna2.tfstate"

  }
}
#azure resource group creation
resource "azurerm_resource_group" "architecture" {
  name     = "3_tier_architecture"
  location = "central india"

}

output "RG001_Name" {
  value = azurerm_resource_group.architecture.name
}

output "Rg001_Loc" {
  value = azurerm_resource_group.architecture.location
}

#Azure vnet ceation for corp
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet1
  resource_group_name = azurerm_resource_group.architecture.name
  location            = azurerm_resource_group.architecture.location
  address_space       = var.cidr_range

}

resource "azurerm_subnet" "sub_IND" {
  name                 = var.subname
  resource_group_name  = azurerm_resource_group.architecture.name
  virtual_network_name = var.vnet1
  address_prefixes     = var.prefixes
  depends_on = [ azurerm_virtual_network.vnet ]
}

# resource "azurerm_public_ip" "Internet" {
#   name                = var.internet01
#   resource_group_name = azurerm_resource_group.architecture.name
#   allocation_method   = "Static"
#   location            = azurerm_resource_group.architecture.location

# }

resource "azurerm_public_ip" "frontend_ip" {
  name                = var.internet02
  resource_group_name = azurerm_resource_group.architecture.name
  allocation_method   = "Static"
  location            = azurerm_resource_group.architecture.location

}
locals {
nsgrules=[
  {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    },
  {
    name                       = "http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
]
  
}


resource "azurerm_network_security_group" "nsg" {
  name                = "nsgindvm001"
  location            =  azurerm_resource_group.architecture.location
  resource_group_name = azurerm_resource_group.architecture.name
depends_on = [ azurerm_subnet.sub_IND,azurerm_resource_group.architecture,azurerm_linux_virtual_machine.Linux_VM,azurerm_windows_virtual_machine.windows_vm ]
  dynamic "security_rule" {
    for_each =local.nsgrules
    content{
    name                       =security_rule.value.name
    priority                   =security_rule.value.priority
    direction                  =security_rule.value.direction
    access                     =security_rule.value.access
    protocol                   =security_rule.value.protocol
    source_port_range          =security_rule.value.source_port_range
    destination_port_range     =security_rule.value.destination_port_range
    source_address_prefix      =security_rule.value.source_address_prefix
    destination_address_prefix =security_rule.value.destination_address_prefix
    }
    

  }
}

resource "azurerm_network_security_group" "nsg2" {
  name                = "nsgindvm002"
  location            =  azurerm_resource_group.architecture.location
  resource_group_name = azurerm_resource_group.architecture.name
depends_on = [ azurerm_linux_virtual_machine.Linux_VM,azurerm_windows_virtual_machine.windows_vm,azurerm_subnet.sub_IND,azurerm_resource_group.architecture ]
  dynamic "security_rule" {
    for_each =values(var.nsg2_rules)
    content{
    name                       =security_rule.value.name
    priority                   =security_rule.value.priority
    direction                  =security_rule.value.direction
    access                     =security_rule.value.access
    protocol                   =security_rule.value.protocol
    source_port_range          =security_rule.value.source_port_range
    destination_port_range     =security_rule.value.destination_port_range
    source_address_prefix      =security_rule.value.source_address_prefix
    destination_address_prefix =security_rule.value.destination_address_prefix
    }
    
  }
}

resource "azurerm_network_interface" "windows_nic" {
count = 2
  name                = "WNIC${count.index}"
  location            = azurerm_resource_group.architecture.location
  resource_group_name = azurerm_resource_group.architecture.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub_IND.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.Internet.id
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  depends_on = [ azurerm_resource_group.architecture,azurerm_virtual_network.vnet,azurerm_subnet.sub_IND ]
  count=2
  name                = "INDSRVW000${count.index}"
  resource_group_name = azurerm_resource_group.architecture.name
  location            =  azurerm_resource_group.architecture.location
  size                = "Standard_B1ms"
  admin_username      = "vmadmin"
  admin_password      = "vmadmin@1234"
  network_interface_ids = [
    azurerm_network_interface.windows_nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "Linux_nic" {
  count=1
  name                = "LNIC${count.index}"
  location            = azurerm_resource_group.architecture.location
  resource_group_name = azurerm_resource_group.architecture.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub_IND.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.Internet2.id
  }
}

resource "azurerm_linux_virtual_machine" "Linux_VM" {
  depends_on = [azurerm_resource_group.architecture,azurerm_subnet.sub_IND,azurerm_virtual_network.vnet,azurerm_windows_virtual_machine.windows_vm,azurerm_network_interface.windows_nic]
  count = 1
  name                = "INDSRVL00${count.index}"
  resource_group_name = azurerm_resource_group.architecture.name
  location            = azurerm_resource_group.architecture.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  admin_password = "vmadmin@1234"
  disable_password_authentication = false
  network_interface_ids = [
    #azurerm_network_interface.Linux_nic[count.index].id,
    element(azurerm_network_interface.Linux_nic.*.id, count.index)
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

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
}


resource "azurerm_lb" "winvm_lb01" {
  name                = var.frontendendpoint
  location            = azurerm_resource_group.architecture.location
  resource_group_name = azurerm_resource_group.architecture.name

  frontend_ip_configuration {
    name                 = "frontendpucblicIP"
    public_ip_address_id = azurerm_public_ip.frontend_ip.id
  }
}

    #  resource "azurerm_lb_frontend_ip_configuration" "fronten_IP_config" {
    #    name                = "example-frontend"
    #    loadbalancer_id     = azurerm_lb.example.id
    #    public_ip_address_id = azurerm_public_ip.example.id
    #  }

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}

