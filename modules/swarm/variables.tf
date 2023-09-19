variable "resource_group_name" {
  description = "Name of resource group"
  type        = string
}

variable "location" {
  description = "Location of resource group"
  type        = string
}

variable "manager_instance_size" {
  description = "Size of manager VM instance"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "manager_disk_size" {
  description = "Size of manager VM Disk"
  type        = number
  default     = 50
}

variable "manager_instance_count" {
  description = "Count of manager instance"
  type        = number
  default     = 1
}

variable "worker_instance_size" {
  description = "Size of worker VM instance"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "worker_disk_size" {
  description = "Size of worker VM Disk"
  type        = number
  default     = 50
}

variable "worker_instance_count" {
  description = "Count of worker instance"
  type        = number
  default     = 1
}

variable "gpu_instance_size" {
  description = "Size of gpu VM instance"
  type        = string
  default     = "Standard_NC4as_T4_v3"
}

variable "gpu_disk_size" {
  description = "Size of gpu VM Disk"
  type        = number
  default     = 50
}

variable "gpu_instance_count" {
  description = "Count of gpu instance"
  type        = number
  default     = 1
}


variable "main_subnet_id" {
  description = "Main Subnet Id"
}

variable "public_key_location" {
  description = "Location of Public Key File"
}
