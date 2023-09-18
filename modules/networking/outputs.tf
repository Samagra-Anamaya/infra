output "main_virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "main_subnet_id" {
  value = azurerm_subnet.main.id
}

output "main_public_ip_id" {
    value = azurerm_public_ip.main.id
}