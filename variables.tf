variable "level0_vnet" {}
variable "level0_subnet" {}
variable "governance_storage_accounts" {}

variable "vm_suffix" {
  description = "(Optional) You can use a suffix to add to the list of Virtual Machines you want to create"
  type        = string
}

variable "os_disk_suffix" {
  description = "(Optional) You can use a suffix to add to the OS Disk of the Virtual Machine you want to create"
  type        = string
}

variable "disk_suffix" {
  description = "(Optional) You can use a suffix to add to the Data Disk(s) of the Virtual Machine you want to create"
  type        = string
}

variable "nic_suffix" {
  description = "(Optional) You can use a suffix to add to the NICs you want to create"
  type        = string
}

variable "vm_object" {
  description = "(Required) configuration object describing the Virtual Machine configuration"
}
