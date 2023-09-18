variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "main_virtual_network_address_space" {
  description = "Virtual network address space"
  type = set(string)
}

variable "main_subnet_address_prefixes" {
  description = "Main subnet address prefixes"
  type = set(string)
}



