resource "azurerm_network_security_group" "worker" {
  name                = "${var.resource_group_name}-worker-sg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow_HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "worker" {
    count = var.worker_instance_count

    name    = "${var.resource_group_name}-worker-${count.index}"
    location            = var.location
    resource_group_name = var.resource_group_name      

    ip_configuration {
      name      = "ipconfig-worker-${count.index}"
      subnet_id = var.main_subnet_id
      private_ip_address_allocation = "Dynamic"  
    }
}

resource "azurerm_network_interface_security_group_association" "worker" {
  count = var.worker_instance_count

  network_interface_id      = azurerm_network_interface.worker[count.index].id
  network_security_group_id = azurerm_network_security_group.worker.id

}

resource "azurerm_linux_virtual_machine" "worker" {
  count = var.worker_instance_count
  name                  = "${var.resource_group_name}-worker-${count.index}"
  computer_name         ="worker-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.worker_instance_size
  admin_username        = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.worker[count.index].id,
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
    name = "${var.resource_group_name}-worker-${count.index}"
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb = var.worker_disk_size
  }

  tags = {
    type = "worker"
  }
}