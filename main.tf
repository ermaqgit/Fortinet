terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "74ee88ea-b737-4a06-b97a-3b7bea6fa8d1"
  features {}
}

resource "azurerm_resource_group" "rgeast" {
  name     = "rgeast"
  location = "East US"
}
resource "azurerm_resource_group" "rgwest" {
  name     = "rgwest"
  location = "West US"
}

# East networking resources
resource "azurerm_virtual_network" "vneteast" {
  name                = "vneteast"
  resource_group_name = azurerm_resource_group.rgeast.name
  location            = azurerm_resource_group.rgeast.location
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "pubsubnet" {
  name                 = "pubsubnet"
  resource_group_name  = azurerm_resource_group.rgeast.name
  virtual_network_name = azurerm_virtual_network.vneteast.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_subnet" "privsubnet" {
  name                 = "privsubnet"
  resource_group_name  = azurerm_resource_group.rgeast.name
  virtual_network_name = azurerm_virtual_network.vneteast.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_public_ip" "vmeast-pip" {
  name                = "vmeast-pip"
  resource_group_name = azurerm_resource_group.vmeast.name
  location            = azurerm_resource_group.vmeast.location
  allocation_method   = "Static"
}

# East Ubuntu VM
resource "azurerm_network_interface" "vmeastnic" {
  name                = "vmeastnic"
  location            = azurerm_resource_group.rgeast.location
  resource_group_name = azurerm_resource_group.rgeast.name

  ip_configuration {
    name                          = "vmeastnic"
    subnet_id                     = azurerm_subnet.privsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmeast-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vmeast" {
  name                = "vmeast"
  resource_group_name = azurerm_resource_group.rgeast.name
  location            = azurerm_resource_group.rgeast.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.vmeastnic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

# West networking resources
resource "azurerm_virtual_network" "vnetwest" {
  name                = "vnetwest"
  resource_group_name = azurerm_resource_group.rgwest.name
  location            = azurerm_resource_group.rgwest.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "pubsubnet" {
  name                 = "pubsubnet"
  resource_group_name  = azurerm_resource_group.rgwest.name
  virtual_network_name = azurerm_virtual_network.vnetwest.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "privsubnet" {
  name                 = "privsubnet"
  resource_group_name  = azurerm_resource_group.rwest.name
  virtual_network_name = azurerm_virtual_network.vnetwest.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vmwest" {
  name                = "vmwest-pip"
  resource_group_name = azurerm_resource_group.vmwest.name
  location            = azurerm_resource_group.vmwest.location
  allocation_method   = "Static"
}
