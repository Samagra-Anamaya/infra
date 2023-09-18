resource "azurerm_resource_group" "resource_group" {
  name     = "deployment"
  location = "Central India"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "samagradeploymentstorage"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "terraform"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}