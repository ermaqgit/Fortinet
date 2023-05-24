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