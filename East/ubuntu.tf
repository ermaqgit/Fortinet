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