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
