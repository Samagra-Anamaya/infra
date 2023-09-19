include {
  path = find_in_parent_folders()
}

dependency "networking" {
  config_path = "../networking"
}

terraform {
  source = "${get_repo_root()}/modules//swarm"
}

inputs = {
    main_subnet_id = dependency.networking.outputs.main_subnet_id
}
