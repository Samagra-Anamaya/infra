locals {
  # Automatically load site-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  site_vars = read_terragrunt_config(find_in_parent_folders("site.hcl"))

  project_name = local.project_vars.locals.project_name

  deployment_storage_resource_group_name = local.site_vars.locals.deployment_storage_resource_group_name
  deployment_storage_account_name        = local.site_vars.locals.deployment_storage_account_name
  deployment_storage_container_name = local.site_vars.locals.deployment_storage_container_name
  resource_group_name = local.site_vars.locals.resource_group_name
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {
     virtual_machine {
      delete_os_disk_on_deletion     = false
    }
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an Blob Storage container
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    resource_group_name  = local.deployment_storage_resource_group_name
    storage_account_name = local.deployment_storage_account_name
    container_name       = local.deployment_storage_container_name
    key                  = "${local.project_name}/${path_relative_to_include("site")}/terraform.tfstate"
  }
}

inputs = merge(
  local.site_vars.locals,
  local.project_vars.locals
)

