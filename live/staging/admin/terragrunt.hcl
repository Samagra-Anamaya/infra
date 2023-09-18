include {
  path = find_in_parent_folders()
}

dependency "networking" {
  config_path = "../networking"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//admin"
}

inputs = {
    main_subnet_id = dependency.networking.outputs.main_subnet_id
}

