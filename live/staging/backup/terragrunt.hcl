include {
  path = find_in_parent_folders()
}

dependency "stateful" {
  config_path = "../stateful"
}


terraform {
  source = "${get_repo_root()}/modules//backup"
}

inputs = {
    stateful_vm_id = dependency.stateful.outputs.stateful_vm_id
}