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
