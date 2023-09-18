variable "resource_group_name" {
  description = "Name of resource group"
  type        = string
}

variable "location" {
  description = "Location of resource group"
  type        = string
}

variable "admin_instance_size" {
  description = "Size of Admin VM instance"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_disk_size" {
  description = "Size of Admin VM Disk"
  type        = number
  default     = 50
}

variable "main_subnet_id" {
  description = "Main Subnet Id"
}

variable "public_key_location" {
  description = "Location of Public Key File"
}