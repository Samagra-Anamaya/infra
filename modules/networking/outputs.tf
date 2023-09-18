output "main_virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "main_subnet_id" {
  value = azurerm_subnet.main.id
}

output "main_public_ip_id" {
    value = azurerm_public_ip.main.id
}

output "admin_public_ip_id" {
    value = azurerm_public_ip.admin.id
}

output "main_security_group_id" {
    value = azurerm_network_security_group.main.id
}