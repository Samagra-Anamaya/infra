resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_group_name}-main-network"
  address_space       = var.main_virtual_network_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "main" {
  name                 = "${var.resource_group_name}-main-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.main_subnet_address_prefixes

}
