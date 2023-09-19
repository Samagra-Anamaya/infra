resource "azurerm_recovery_services_vault" "vault" {
  name                = "${var.resource_group_name}-vault"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "policy" {
  name                = "${var.resource_group_name}-vm-backup-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  backup {
    frequency = "Daily"
    time      = "20:30"
  }
  retention_daily {
    count = 10
  }
}

resource "azurerm_backup_protected_vm" "backup" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = var.stateful_vm_id
  backup_policy_id    = azurerm_backup_policy_vm.policy.id
}