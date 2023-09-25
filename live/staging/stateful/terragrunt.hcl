include {
  path = find_in_parent_folders()
}

dependency "networking" {
  config_path = "../networking"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//stateful"
}

inputs = {
    main_subnet_id = dependency.networking.outputs.main_subnet_id
    stateful_instance_size = "Standard_E2bds_v5"

}

