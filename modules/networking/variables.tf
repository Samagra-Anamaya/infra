variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "main_virtual_network_name" {
  description = "Virtual network name"
}

variable "main_virtual_network_address_space" {
  description = "Virtual network address space"
  type = set(string)
}

variable "main_subnet_name" {
  description = "Main subnet name"
}

variable "main_subnet_address_prefixes" {
  description = "Main subnet address prefixes"
  type = set(string)
}

variable "main_subnet_security_group_name" {
  description = "Main subnet security group name"
}

variable "public_ip_name" {
    description = "Public ip name"
}