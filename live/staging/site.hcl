locals {
  location                               = "Central India"
  resource_group_name                    = "anamaya-staging"
  deployment_storage_resource_group_name = "deployment"
  deployment_storage_account_name        = "samagradeploymentstorage"
  deployment_storage_container_name      = "terraform"

  main_virtual_network_name              = "${local.resource_group_name}-main-network"
  main_virtual_network_address_space     = ["10.6.1.128/25"]
  main_subnet_name                       = "${local.resource_group_name}-main-subnet"
  main_subnet_address_prefixes           = ["10.6.1.128/26"]

  gpu_instance_count                     = 0
}