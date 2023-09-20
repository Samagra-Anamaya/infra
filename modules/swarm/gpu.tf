resource "azurerm_network_security_group" "gpu" {
  name                = "${var.resource_group_name}-gpu-sg"
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

resource "azurerm_network_interface" "gpu" {
    count = var.gpu_instance_count

    name    = "${var.resource_group_name}-gpu-${count.index}"
    location            = var.location
    resource_group_name = var.resource_group_name      

    ip_configuration {
      name      = "ipconfig-gpu-${count.index}"
      subnet_id = var.main_subnet_id
      private_ip_address_allocation = "Dynamic"  
    }
}

resource "azurerm_network_interface_security_group_association" "gpu" {
  count = var.gpu_instance_count

  network_interface_id      = azurerm_network_interface.gpu[count.index].id
  network_security_group_id = azurerm_network_security_group.gpu.id

}

resource "azurerm_linux_virtual_machine" "gpu" {
  count = var.gpu_instance_count
  name                  = "${var.resource_group_name}-gpu-${count.index}"
  computer_name         ="gpu-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.gpu_instance_size
  admin_username        = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.gpu[count.index].id,
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
    name = "${var.resource_group_name}-gpu-${count.index}"
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
    disk_size_gb = var.gpu_disk_size
  }

  tags = {
    type = "gpu"
  }
}