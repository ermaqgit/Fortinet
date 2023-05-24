terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rgeast" {
  name     = "rg-east"
  location = "East US"
}

resource "azurerm_virtual_network" "vneteast" {
  name                = "vnet-east"
  resource_group_name = azurerm_resource_group.rgeast.name
  location            = azurerm_resource_group.rgeast.location
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "pubsubnet" {
  name                 = "pub-subnet"
  resource_group_name  = azurerm_resource_group.rgeast.name
  virtual_network_name = azurerm_virtual_network.vneteast.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_subnet" "privsubnet" {
  name                 = "priv-subnet"
  resource_group_name  = azurerm_resource_group.rgeast.name
  virtual_network_name = azurerm_virtual_network.vneteast.name
  address_prefixes     = ["10.100.1.0/24"]
}

