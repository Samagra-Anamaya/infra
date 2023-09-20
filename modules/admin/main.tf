resource "azurerm_network_security_group" "admin" {
  name                = "${var.resource_group_name}-admin-sg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "admin" {
  name                = "${var.resource_group_name}-admin-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "admin" {
    name    = "${var.resource_group_name}-admin"
    location            = var.location
    resource_group_name = var.resource_group_name      

    ip_configuration {
      name      = "ipconfig-admin"
      subnet_id = var.main_subnet_id
      private_ip_address_allocation = "Dynamic"  
      public_ip_address_id = azurerm_public_ip.admin.id
    }
}

resource "azurerm_network_interface_security_group_association" "admin" {
  network_interface_id      = azurerm_network_interface.admin.id
  network_security_group_id = azurerm_network_security_group.admin.id
}

resource "azurerm_linux_virtual_machine" "admin" {
  name                  = "${var.resource_group_name}-admin"
  computer_name         ="admin"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.admin_instance_size
  admin_username        = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.admin.id,
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
    name = "${var.resource_group_name}-admin"
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = var.admin_disk_size
  }

  tags = {
    type = "admin"
  }

}

