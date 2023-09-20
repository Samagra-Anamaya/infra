resource "azurerm_network_security_group" "stateful" {
  name                = "${var.resource_group_name}-stateful-sg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "stateful" {
    name    = "${var.resource_group_name}-stateful"
    location            = var.location
    resource_group_name = var.resource_group_name      

    ip_configuration {
      name      = "ipconfig-stateful"
      subnet_id = var.main_subnet_id
      private_ip_address_allocation = "Dynamic"  
    }
}

resource "azurerm_network_interface_security_group_association" "stateful" {
  network_interface_id      = azurerm_network_interface.stateful.id
  network_security_group_id = azurerm_network_security_group.stateful.id
}

resource "azurerm_linux_virtual_machine" "stateful" {
  name                  = "${var.resource_group_name}-stateful"
  computer_name         ="stateful"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.stateful_instance_size
  admin_username        = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.stateful.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${var.public_key_location}")
  }

   source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name = "${var.resource_group_name}-stateful"
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = var.stateful_disk_size
  }

  tags = {
    type = "stateful"
  }

}

