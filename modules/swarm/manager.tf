resource "azurerm_network_security_group" "manager" {
  name                = "${var.resource_group_name}-manager-sg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "manager" {
  name                = "${var.resource_group_name}-manager-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "manager" {
    count = var.manager_instance_count

    name    = "${var.resource_group_name}-manager-${count.index}"
    location            = var.location
    resource_group_name = var.resource_group_name      

    ip_configuration {
      name      = "ipconfig-manager-${count.index}"
      subnet_id = var.main_subnet_id
      private_ip_address_allocation = "Dynamic"  
      public_ip_address_id = "${count.index == 0 ? azurerm_public_ip.manager.id  : null}"
    }
}

resource "azurerm_network_interface_security_group_association" "manager" {
  count = var.manager_instance_count

  network_interface_id      = azurerm_network_interface.manager[count.index].id
  network_security_group_id = azurerm_network_security_group.manager.id

}

resource "azurerm_linux_virtual_machine" "manager" {
  count = var.manager_instance_count
  name                  = "${var.resource_group_name}-manager-${count.index}"
  computer_name         ="manager-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.manager_instance_size
  admin_username        = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.manager[count.index].id,
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
    name = "${var.resource_group_name}-manager-${count.index}"
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb = var.manager_disk_size
  }

  tags = {
    type = "manager"
  }
}